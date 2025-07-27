package com.tomwyr.features.search

import io.kvision.core.*
import io.kvision.form.text.TextInput
import io.kvision.form.text.textInput
import io.kvision.html.div
import io.kvision.html.i
import io.kvision.utils.perc
import io.kvision.utils.px

fun Container.searchInput(init: TextInput.() -> Unit) {
    div {
        position = Position.RELATIVE

        textInput(className = "search-query") {
            display = Display.BLOCK
            width = 100.perc
            fontSize = 14.px
            paddingLeft = 38.px
            outline = Outline(style = OutlineStyle.NONE)

            i(className = "fas fa-magnifying-glass search-icon") {
                color = Color.name(Col.DARKGRAY)
                position = Position.ABSOLUTE
                width = 16.px
                height = 16.px
                top = 50.perc
                marginLeft = 12.px
            }
            
            init()
        }
    }
}
