package com.tomwyr.features.common

import io.kvision.core.Container
import io.kvision.html.Div
import io.kvision.html.div
import io.kvision.html.span

fun Container.loadingIndicator(init: (Div.() -> Unit)? = null) {
    div(className = "wave") {
        span(className = "dot")
        span(className = "dot")
        span(className = "dot")
        
        init?.invoke(this)
    }
}
