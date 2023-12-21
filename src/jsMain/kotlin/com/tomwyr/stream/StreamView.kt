package com.tomwyr.stream

import com.tomwyr.LateInfo
import com.tomwyr.StreamStatus
import com.tomwyr.StreamerInfo
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.*
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

private fun Container.container(init: Div.() -> Unit) {
    div {
        width = 100.vw
        minHeight = 100.vh
        padding = 2.rem
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        alignItems = AlignItems.CENTER
        background = Background(Color.name(Col.GHOSTWHITE))

        init()
    }
}

private fun Container.header() {
    div {
        display = Display.BLOCK
        paddingTop = 4.rem

        h1("Late Checker") {
            colorName = Col.DARKGRAY
        }
        div {
            textAlign = TextAlign.RIGHT

            h6("1.0.0") {
                colorName = Col.LIGHTGRAY
            }
        }
    }
}

private fun Container.content(result: Result<LateInfo, LateServiceFailure>) {
    div {
        flexGrow = 1
        flexShrink = 0
        flexBasis = auto
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        justifyContent = JustifyContent.CENTER
        alignItems = AlignItems.CENTER

        when (result) {
            is Success -> successView(result.value)
            is Loading -> loadingView()
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
                borderRadius = 50.perc
                width = 8.rem
                height = 8.rem
            }
        }

        span("$streamStatus") {
            colorName = Col.GRAY
        }

        div().bind(StreamModel.refreshStatus) {
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
                val weekDay = streamStart.toLocalDateTime(streamerInfo.timeZone).dayOfWeek.shortName
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
        colorName = Col.GRAY
    }

    div(className = "action-button") {
        span("Retry")
    }.onClick { StreamModel.loadLateInfo() }
}

private fun Container.footer() {
    div {
        width = 100.perc
        flexShrink = 0
        textAlign = TextAlign.LEFT

        link("GitHub", "https://github.com/tomwyr/late-checker", target = "_blank") {
            colorName = Col.DARKGRAY
            textDecoration = TextDecoration(TextDecorationLine.NONE)
        }
    }
}
