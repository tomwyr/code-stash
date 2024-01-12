package com.tomwyr.features.common

import io.kvision.core.Container
import io.kvision.html.div
import io.kvision.html.span

fun Container.loadingView(padding: Padding = Padding()) {
    div(className = "wave") {
        applyPadding(padding)

        span(className = "dot")
        span(className = "dot")
        span(className = "dot")
    }
}
