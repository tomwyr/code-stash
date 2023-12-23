package com.tomwyr.stream

import com.tomwyr.LateInfo
import com.tomwyr.StreamStatus
import com.tomwyr.StreamerInfo
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.Failure
import com.tomwyr.utils.Result
import com.tomwyr.utils.Success
import com.tomwyr.utils.extensions.*
import io.kvision.core.*
import io.kvision.html.*
import io.kvision.panel.SimplePanel
import io.kvision.state.bind
import io.kvision.utils.*
import kotlinx.datetime.Instant
import kotlinx.datetime.toLocalDateTime
import kotlin.time.Duration.Companion.hours

object StreamView : SimplePanel() {
    init {
        addAfterInsertHook {
            StreamModel.initialize()
        }

        bind(StreamModel.lateInfo) { result ->
            container {
                header()
                content(result)
                footer()
            }
        }
    }
}

private fun StyledComponent.container(init: StyledComponent.() -> Unit) {
    width = 100.vw
    minHeight = 100.vh
    display = Display.FLEX
    flexDirection = FlexDirection.COLUMN
    alignItems = AlignItems.CENTER

    init()
}

private fun Container.header() {
    div {
        display = Display.BLOCK
        paddingTop = 4.rem

        h1("Late Checker") {
            colorName = Col.DARKGRAY
            margin = 1.px
        }
        div().bind(StreamModel.version) { version ->
            textAlign = TextAlign.RIGHT

            h4(version) {
                margin = 1.px
                colorName = Col.LIGHTGRAY
            }
        }
    }
}

private fun Container.content(result: Result<LateInfo, LateServiceFailure>?) {
    div {
        flexGrow = 1
        flexShrink = 0
        flexBasis = auto
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        justifyContent = JustifyContent.CENTER
        alignItems = AlignItems.CENTER

        when (result) {
            null -> loadingView()
            is Success -> successView(result.value)
            is Failure -> failureView(result.value)
        }
    }
}

private fun Container.successView(lateInfo: LateInfo) {
    with(lateInfo) {
        link("", streamerInfo.streamUrl, target = "_blank") {
            margin = 1.rem
            borderRadius = 50.perc

            image(streamerInfo.imageUrl) {
                alt = "Stream logo and link"
                borderRadius = 50.perc
                width = 8.rem
                height = 8.rem
            }
        }

        span("$streamStatus") {
            colorName = Col.GRAY
            fontSize = 20.px
            marginTop = 1.rem
        }

        div().bind(StreamModel.viewRefresh) {
            val description = when (streamStatus) {
                StreamStatus.Live -> ::liveDescription
                StreamStatus.Late -> ::lateDescription
                StreamStatus.Offline -> ::offlineDescription
            }

            description(streamerInfo, streamStart)
        }
    }
}

private fun Container.liveDescription(streamerInfo: StreamerInfo, streamStart: Instant) {
    val streamer = streamerInfo.name
    val timePassed = streamStart.untilNow().formatHms()

    p {
        b(streamer)
        span(" has been online for ")
        b(timePassed)
        span(".")
    }
}

private fun Container.lateDescription(streamerInfo: StreamerInfo, streamStart: Instant) {
    val streamer = streamerInfo.name
    val timePassed = streamStart.untilNow().formatHms()

    p {
        b(streamer)
        span(" has been late for ")
        b(timePassed)
        span(".")
    }
}

private fun Container.offlineDescription(streamerInfo: StreamerInfo, streamStart: Instant) {
    fun P.nextStreamTime() {
        when (val timeLeft = streamStart.sinceNow()) {
            in 0.hours..1.hours -> {
                span("in ")
                b(timeLeft.formatHms())
            }

            else -> {
                val weekDay = streamStart.toLocalDateTime(streamerInfo.timeZone).dayOfWeek.displayName
                val time = streamStart.format("HH:mm", streamerInfo.timeZone.id)

                span("on ")
                b(weekDay)
                span(" at ")
                b(time)
            }
        }
    }

    val streamer = streamerInfo.name

    p {
        b(streamer)
        span(" is currently offline. Next stream expected ")
        nextStreamTime()
        span(".")
    }
}

private fun Container.loadingView() {
    div(className = "wave") {
        span(className = "dot")
        span(className = "dot")
        span(className = "dot")
    }
}

private fun Container.failureView(failure: LateServiceFailure) {
    span(failure.message) {
        margin = 1.rem
        colorName = Col.DARKGRAY
    }

    div(className = "action-button") {
        span("Retry")
    }.onClick { StreamModel.retry() }
}

private fun Container.footer() {
    div().bind(StreamModel.repoUrl) { repoUrl ->
        width = 100.perc
        flexShrink = 0
        textAlign = TextAlign.LEFT

        link("", url = repoUrl, target = "_blank") {
            display = Display.INLINEBLOCK
            borderRadius = 50.perc
            margin = 1.rem

            gitHubLogo {
                width = 3.rem
                height = 3.rem
            }
        }
    }
}

private fun Container.gitHubLogo(init: Div.() -> Unit) {
    val svg = """<svg class="github-logo" viewBox="0 0 98 96" xmlns="http://www.w3.org/2000/svg">
    <path fill="" fill-rule="evenodd" clip-rule="evenodd"
        d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z"
    />
</svg>"""

    div(content = svg, rich = true) {
        init()
    }
}
