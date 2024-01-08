package com.tomwyr.features.search

import io.kvision.core.Container
import io.kvision.core.onClick
import io.kvision.html.Div
import io.kvision.html.span
import kotlinx.browser.window

fun Container.searchViewButton() {
    add(SearchViewButton())
}

class SearchViewButton : Div() {
    init {
        addAfterInsertHook {
            window.onkeydown = { showOverlay() }
        }

        addAfterDestroyHook {
            window.onkeydown = null
        }

        span("Search")

        onClick { showOverlay() }
    }

    private fun showOverlay() {
        SearchOverlay.overlayVisible.value = true
    }
}
