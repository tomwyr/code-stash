package com.example.widgets

import io.kvision.core.Container
import io.kvision.html.Div

fun Container.loadingIndicator(init: (LoadingIndicator.() -> Unit)? = null): LoadingIndicator {
    return LoadingIndicator(init).also { add(it) }
}

class LoadingIndicator(init: (LoadingIndicator.() -> Unit)?) : Div(className = "loading-indicator") {
    init {
        init?.invoke(this)
    }
}
