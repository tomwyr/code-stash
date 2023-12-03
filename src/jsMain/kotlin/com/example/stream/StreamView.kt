package com.example.stream

import com.example.LateInfo
import com.example.services.LateServiceFailure
import com.example.utils.Failure
import com.example.utils.Loading
import com.example.utils.Result
import com.example.utils.Success
import io.kvision.core.*
import io.kvision.html.*
import io.kvision.panel.SimplePanel
import io.kvision.state.bind
import io.kvision.utils.*

object StreamView : SimplePanel() {
    init {
        addAfterInsertHook {
            StreamModel.loadLateInfo()
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
        span("$streamStatus") {
            colorName = Col.GRAY
        }
    }
}

private fun Container.loadingView() {
    div(className = "loading-indicator")
}

private fun Container.failureView(failure: LateServiceFailure) {
    image("images/deadge.webp") {
        width = 3.rem
        height = 3.rem
    }
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
