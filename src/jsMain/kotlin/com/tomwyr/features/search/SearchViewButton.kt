package com.tomwyr.features.search

import com.tomwyr.common.addKeyListener
import io.kvision.core.Container
import io.kvision.core.onClick
import io.kvision.html.Div
import io.kvision.html.span

fun Container.searchViewButton() {
    add(SearchViewButton())
}

class SearchViewButton : Div() {
    init {
        addKeyListener {
            if (it.key == "/") {
                showOverlay()
                it.preventDefault()
            }
        }

        span("Search")

        onClick { showOverlay() }
    }

    private fun showOverlay() {
        SearchOverlay.overlayVisible.value = true
    }
}
