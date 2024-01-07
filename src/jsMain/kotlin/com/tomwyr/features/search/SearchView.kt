package com.tomwyr.features.search

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import io.kvision.core.Container
import io.kvision.core.Display
import io.kvision.core.FlexDirection
import io.kvision.core.onInput
import io.kvision.form.text.textInput
import io.kvision.html.div
import io.kvision.html.li
import io.kvision.html.span
import io.kvision.html.ul
import io.kvision.panel.SimplePanel
import io.kvision.state.bind

fun Container.streamerSearchView() {
    add(StreamerSearchView())
}

class StreamerSearchView : SimplePanel() {
    init {
        addAfterInsertHook {
            StreamerSearchModel.initialize()
        }

        div {
            display = Display.FLEX
            flexDirection = FlexDirection.COLUMN

            textInput {
                placeholder = "Streamer name"
                onInput {
                    StreamerSearchModel.searchQueryInput.value = value ?: ""
                }
            }

            span().bind(StreamerSearchModel.searchQuery) {
                content = when (it) {
                    is Ok -> null
                    is Err -> when (it.error) {
                        SearchQueryFailure.Empty -> null
                        SearchQueryFailure.InvalidFormat -> "Only letters and digits are allowed."
                        SearchQueryFailure.TooShort -> "At least 3 characters are required"
                    }
                }
            }

            div().bind(StreamerSearchModel.streamers) { result ->
                when (result) {
                    null -> Unit
                    is Ok -> ul {
                        result.value.forEach {
                            li(it.name)
                        }
                    }

                    is Err -> span("Error. Please try again.")
                }
            }
        }
    }
}
