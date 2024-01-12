package com.tomwyr.features.stream

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.github.michaelbull.result.Result
import com.tomwyr.LateInfo
import com.tomwyr.StreamStatus
import com.tomwyr.StreamerInfo
import com.tomwyr.common.extensions.*
import com.tomwyr.features.common.AppModel
import com.tomwyr.features.common.loadingView
import com.tomwyr.features.search.searchViewButton
import com.tomwyr.services.LateServiceFailure
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

        bind(StreamModel.lateInfo) { result ->
            container {
                header {
                    appInfo()
                    searchViewButton()
                }
                lateInfo(result)
            }
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

        appInfo()
        searchViewButton()
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

private fun Container.lateInfo(result: Result<LateInfo, LateServiceFailure>?) {
    div {
        flexGrow = 1
        flexShrink = 0
        flexBasis = auto
        paddingBottom = 48.px
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        justifyContent = JustifyContent.CENTER
        alignItems = AlignItems.CENTER

        when (result) {
            null -> loadingView()
            is Ok -> successView(result.value)
            is Err -> failureView(result.error)
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

private fun Container.failureView(failure: LateServiceFailure) {
    span(failure.message) {
        margin = 1.rem
        colorName = Col.DARKGRAY
    }

    div(className = "action-button") {
        span("Retry")
    }.onClick { StreamModel.retry() }
}
