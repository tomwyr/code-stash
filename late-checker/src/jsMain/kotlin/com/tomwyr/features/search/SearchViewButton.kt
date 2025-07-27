package com.tomwyr.features.search

import com.tomwyr.utils.addKeyListener
import io.kvision.core.*
import io.kvision.html.Div
import io.kvision.utils.perc
import io.kvision.utils.px
import io.kvision.utils.rem

fun Container.searchViewButton() {
    add(SearchViewButton())
}

class SearchViewButton : Div() {
    init {
        width = 100.perc
        maxWidth = 320.px
        marginLeft = 0.5.rem

        addKeyListener {
            if (it.key == "/") {
                showOverlay()
                it.preventDefault()
            }
        }

        searchInput {
            placeholder = "Type / to search"
            background = Background(Color.name(Col.GHOSTWHITE))
            cursor = Cursor.POINTER
            readonly = true
        }

        onClick { showOverlay() }
    }

    private fun showOverlay() {
        SearchOverlay.visibility.value = true
    }
}
