package com.tomwyr.features.common

import io.kvision.core.CssSize
import io.kvision.core.StyledComponent

class Padding(
        val top: CssSize? = null,
        val bottom: CssSize? = null,
        val left: CssSize? = null,
        val right: CssSize? = null,
)

fun StyledComponent.applyPadding(padding: Padding) {
    paddingTop = padding.top
    paddingBottom = padding.bottom
    paddingLeft = padding.left
    paddingRight = padding.right
}
