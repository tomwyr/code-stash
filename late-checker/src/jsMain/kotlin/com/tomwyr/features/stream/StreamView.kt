package com.tomwyr.features.stream

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.tomwyr.LateInfo
import com.tomwyr.StreamStatus
import com.tomwyr.StreamerInfo
import com.tomwyr.extensions.*
import com.tomwyr.features.common.AppModel
import com.tomwyr.features.common.loadingIndicator
import com.tomwyr.features.history.historyView
import com.tomwyr.features.search.searchViewButton
import com.tomwyr.utils.here
import io.kvision.core.*
import io.kvision.html.*
import io.kvision.panel.SimplePanel
import io.kvision.state.bind
import io.kvision.utils.*
import kotlinx.datetime.Instant
import kotlinx.datetime.toLocalDateTime
import kotlin.time.Duration.Companion.hours

fun Container.streamView() {
    add(StreamView())
}

class StreamView : SimplePanel() {
    init {
        addAfterInsertHook { StreamModel.initialize() }

        container {
            header {
                appInfo()
                searchViewButton()
            }
            historyView()
            lateInfo()
        }
    }
}

private fun StreamView.container(init: StreamView.() -> Unit) {
    width = 100.vw
    minHeight = 100.vh
    display = Display.FLEX
    flexDirection = FlexDirection.COLUMN
    alignItems = AlignItems.CENTER

    init()
}

private fun StreamView.header(init: Div.() -> Unit) {
    div {
        width = 100.perc
        display = Display.FLEX
        flexDirection = FlexDirection.ROW
        padding = 1.rem
        justifyContent = JustifyContent.SPACEBETWEEN

        init()
    }
}

private fun Container.appInfo() {
    div {
        display = Display.BLOCK
        marginRight = 0.5.rem

        h2("Late Checker") {
            colorName = Col.DARKGRAY
            margin = 1.px
            whiteSpace = WhiteSpace.NOWRAP
        }
        div().bind(AppModel.version) { version ->
            h5("v$version") {
                margin = 1.px
                colorName = Col.LIGHTGRAY
            }
        }
    }
}

private fun Container.lateInfo() {
    div().bind(StreamModel.lateInfo) { state ->
        flexGrow = 1
        flexShrink = 0
        flexBasis = auto
        paddingBottom = 48.px
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        justifyContent = JustifyContent.CENTER
        alignItems = AlignItems.CENTER

        when (state) {
            is LateInfoState.Initial -> emptyView()
            is LateInfoState.Loading -> loadingView(state.streamerInfo)
            is LateInfoState.Result -> when (val result = state.result) {
                is Ok -> successView(result.value)
                is Err -> failureView(result.error)
            }
        }
    }
}

private fun Container.emptyView() {
    div {
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        textAlign = TextAlign.CENTER

        h2("Welcome to Late Checker") {
            color = Color.name(Col.DIMGRAY)
            margin = 24.px
        }
        h4("Search streamers by clicking on the search box") {
            color = Color.name(Col.DARKGRAY)
            margin = 4.px
        }
        h4("or pressing the '/' key") {
            color = Color.name(Col.DARKGRAY)
            margin = 4.px
        }
    }
}

private fun Container.loadingView(streamerInfo: StreamerInfo) {
    h2(streamerInfo.name) {
        color = Color.name(Col.LIGHTGRAY)
    }

    loadingIndicator {
        marginTop = 56.px
        marginBottom = 56.px
    }
}

private fun Container.successView(lateInfo: LateInfo) {
    with(lateInfo) {
        h1(streamerInfo.name) {
            color = Color.name(Col.DIMGRAY)
            marginTop = 0.px
            marginBottom = 16.px
        }

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
            fontSize = 20.px
            marginTop = 1.rem
        }

        div().bind(StreamModel.viewRefresh) {
            marginBottom = 40.px

            if (streamStart == null) {
                return@bind
            }

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
                val weekDay = streamStart.toLocalDateTime(here()).dayOfWeek.displayName
                val time = streamStart.format("HH:mm", here().id)

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
        span(" is currently offline. Next stream is expected ")
        nextStreamTime()
        span(".")
    }
}

private fun Container.failureView(error: LateInfoError) {
    h2(error.streamerInfo.name) {
        color = Color.name(Col.LIGHTGRAY)
    }

    span(error.cause.message) {
        margin = 1.rem
    }

    div(className = "action-button") {
        marginTop = 20.px

        span("Retry")
    }.onClick { StreamModel.retry() }
}
