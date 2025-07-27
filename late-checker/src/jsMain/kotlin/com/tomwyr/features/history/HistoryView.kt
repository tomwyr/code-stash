package com.tomwyr.features.history

import com.tomwyr.features.stream.StreamModel
import io.kvision.core.*
import io.kvision.html.image
import io.kvision.html.li
import io.kvision.html.span
import io.kvision.html.ul
import io.kvision.panel.SimplePanel
import io.kvision.state.bind
import io.kvision.utils.px

fun Container.historyView() {
    add(HistoryView())
}

class HistoryView : SimplePanel() {
    init {
        addAfterInsertHook { HistoryModel.initialize() }

        ul().bind(HistoryModel.streamers) { streamers ->
            display = Display.FLEX
            flexDirection = FlexDirection.COLUMN
            position = Position.ABSOLUTE
            right = 0.px
            marginRight = 12.px

            streamers.forEach { streamer ->
                li(className = "stream-history-item") {
                    span(streamer.name)

                    image(streamer.imageUrl, className = "streamer-avatar") {
                        alt = "Stream logo and link"
                    }
                    
                    onClick {
                        HistoryModel.onStreamerClick(streamer)
                    }
                }
            }
        }
    }
}
