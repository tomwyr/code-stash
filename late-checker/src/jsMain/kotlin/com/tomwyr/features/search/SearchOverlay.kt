package com.tomwyr.features.search

import com.tomwyr.utils.addKeyListener
import io.kvision.core.*
import io.kvision.html.Div
import io.kvision.state.ObservableValue
import io.kvision.utils.perc
import io.kvision.utils.px
import io.kvision.utils.rem

fun Container.searchOverlay(init: (Container.() -> Unit)?) {
    add(SearchOverlay)
    init?.invoke(SearchOverlay)
}

object SearchOverlay : Div(className = "overlay-blur") {
    val visibility = ObservableValue(false)

    init {
        display = Display.NONE
        position = Position.ABSOLUTE
        top = 0.px
        left = 0.px
        width = 100.perc
        height = 100.perc
        paddingTop = 4.rem
        background = Background(Color("#ffffff80"))

        addKeyListener {
            if (it.key == "Escape") visibility.value = false
        }

        onClick { visibility.value = false }

        visibility.subscribe { visible ->
            display = if (visible) Display.BLOCK else Display.NONE
        }

    }
}
