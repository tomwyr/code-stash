package com.tomwyr.features.search

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.tomwyr.StreamerInfo
import com.tomwyr.features.common.loadingIndicator
import io.kvision.core.*
import io.kvision.html.*
import io.kvision.panel.SimplePanel
import io.kvision.state.bind
import io.kvision.utils.perc
import io.kvision.utils.px
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
        alignItems = AlignItems.CENTER

        div {
            width = 100.perc
            maxWidth = 384.px
            background = Background(Color.name(Col.WHITE))
            padding = 1.rem
            borderRadius = 0.75.rem
            boxShadow = BoxShadow(1.px, 1.px, 2.px, 2.px, Color("#00000033"))

            onClick { it.stopPropagation() }

            queryInput()
            validationMessage()
            searchResults()
        }
    }
}

private fun Div.queryInput() {
    searchInput {
        placeholder = "Streamer name..."

        SearchOverlay.overlayVisible.subscribe { visible ->
            if (visible) focus()
        }

        onInput {
            SearchModel.searchQueryInput.value = value ?: ""
        }
    }
}

private fun Div.validationMessage() {
    span().bind(SearchModel.searchQuery) {
        position = Position.RELATIVE
        top = 2.px
        left = 4.px
        fontSize = 14.px
        color = Color.name(Col.INDIANRED)

        content = when (it) {
            is Ok -> null
            is Err -> when (it.error) {
                SearchQueryFailure.Empty -> null
                SearchQueryFailure.InvalidFormat -> "Only letters, digits and underscore are allowed."
                SearchQueryFailure.TooShort -> "At least 3 characters are required."
            }
        }

        if (content == null) hide() else show()
    }
}

private fun Div.searchResults() {
    div().bind(SearchModel.streamers) { state ->
        when (state) {
            StreamersState.Initial -> Unit

            StreamersState.Loading -> loadingIndicator {
                paddingTop = 3.25.rem
                paddingBottom = 1.75.rem
                paddingLeft = 1.rem
                paddingRight = 1.rem
            }

            is StreamersState.Result -> when (state.result) {
                is Ok -> ul {
                    marginBottom = 0.px

                    state.result.value.forEach {
                        streamerTile(it)
                    }
                }

                is Err -> span("Something went wrong. Please try again.")
            }
        }
    }
}

private fun Container.streamerTile(streamerInfo: StreamerInfo) {
    li(className = "search-result-item") {
        display = Display.FLEX
        flexDirection = FlexDirection.ROW
        alignItems = AlignItems.CENTER
        cursor = Cursor.POINTER

        image(streamerInfo.imageUrl, className = "streamer-avatar") {
            marginRight = 8.px
        }

        span(streamerInfo.name)

        onClick {
            SearchOverlay.overlayVisible.value = false
            SearchModel.onStreamerClick(streamerInfo)
        }
    }
}
