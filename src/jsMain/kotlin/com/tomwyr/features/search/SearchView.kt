package com.tomwyr.features.search

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import io.kvision.core.*
import io.kvision.form.text.textInput
import io.kvision.html.*
import io.kvision.panel.SimplePanel
import io.kvision.state.bind
import io.kvision.utils.perc
import io.kvision.utils.rem

fun Container.searchView() {
    add(SearchView())
}

class SearchView : SimplePanel() {
    init {
        addAfterInsertHook { SearchModel.initialize() }

        width = 100.perc
        height = 100.perc
        display = Display.FLEX
        flexDirection = FlexDirection.COLUMN
        justifyContent = JustifyContent.CENTER
        alignItems = AlignItems.CENTER

        div {
            background = Background(Color.name(Col.WHITE))
            padding = 1.rem

            onClick { it.stopPropagation() }

            queryInput()
            validationMessage()
            searchResults()
        }
    }
}

private fun Div.queryInput() {
    textInput {
        SearchOverlay.overlayVisible.subscribe { visible ->
            if (visible) focus()
        }

        placeholder = "Streamer name"
        onInput {
            SearchModel.searchQueryInput.value = value ?: ""
        }
    }
}

private fun Div.validationMessage() {
    span().bind(SearchModel.searchQuery) {
        content = when (it) {
            is Ok -> null
            is Err -> when (it.error) {
                SearchQueryFailure.Empty -> null
                SearchQueryFailure.InvalidFormat -> "Only letters and digits are allowed."
                SearchQueryFailure.TooShort -> "At least 3 characters are required"
            }
        }
    }
}

private fun Div.searchResults() {
    div().bind(SearchModel.streamers) { result ->
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
