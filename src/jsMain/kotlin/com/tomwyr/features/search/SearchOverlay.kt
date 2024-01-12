package com.tomwyr.features.search

import com.tomwyr.common.addKeyListener
import io.kvision.core.*
import io.kvision.html.Div
import io.kvision.state.ObservableValue
import io.kvision.utils.perc
import io.kvision.utils.px

fun Container.searchOverlay(init: (Container.() -> Unit)?) {
    add(SearchOverlay)
    init?.invoke(SearchOverlay)
}

object SearchOverlay : Div(className = "overlay-blur") {
    val overlayVisible = ObservableValue(false)

    init {
        position = Position.ABSOLUTE
        top = 0.px
        left = 0.px
        width = 100.perc
        height = 100.perc
        background = Background(Color("#ffffff80"))
        visible = false

        addKeyListener {
            if (it.key == "Escape") hide()
        }

        onClick { overlayVisible.value = false }

        overlayVisible.subscribe {
            if (it) show() else hide()
        }
    }
}
