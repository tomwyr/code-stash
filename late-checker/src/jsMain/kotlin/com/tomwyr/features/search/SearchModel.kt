package com.tomwyr.features.search

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.github.michaelbull.result.Result
import com.tomwyr.SearchQuery
import com.tomwyr.StreamerInfo
import com.tomwyr.extensions.asFlow
import com.tomwyr.features.stream.StreamModel
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.MainScope
import com.tomwyr.utils.launchCatching
import io.kvision.state.ObservableValue
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.*
import kotlin.time.Duration.Companion.seconds

typealias StreamersResult = Result<List<StreamerInfo>, LateServiceFailure>
typealias SearchQueryResult = Result<SearchQuery, SearchQueryFailure>

sealed class StreamersState {
    data object Initial : StreamersState()
    data object Loading : StreamersState()
    class Result(val result: StreamersResult) : StreamersState()
}

@OptIn(FlowPreview::class, ExperimentalCoroutinesApi::class)
object SearchModel {
    private var initialized = false

    private val lateService = LateService()

    val searchQueryInput = ObservableValue("")

    val searchQuery = ObservableValue(processInput(""))

    val streamers = ObservableValue<StreamersState>(StreamersState.Initial)

    fun initialize() {
        if (!initialized) initialized = true else return

        MainScope.launchCatching {
            getSearchQueryFlow().collectLatest { searchQuery.value = it }
        }

        MainScope.launchCatching {
            getSearchQueryFlow().mapNotNull { it as? Ok }
                    .onEach { streamers.value = StreamersState.Loading }
                    .mapLatest { searchStreamers(it.value) }
                    .collect { streamers.value = StreamersState.Result(it) }
        }
    }

    fun onStreamerClick(streamerInfo: StreamerInfo) {
        StreamModel.selectedStreamer.value = streamerInfo
    }

    private fun getSearchQueryFlow(): Flow<SearchQueryResult> {
        return searchQueryInput.asFlow().distinctUntilChanged().debounce(1.seconds).map { processInput(it) }
    }

    private fun processInput(input: String): SearchQueryResult {
        val value = input.replace(" ", "")

        return when {
            value.isEmpty() -> Err(SearchQueryFailure.Empty)
            !value.matches(SearchQuery.pattern) -> Err(SearchQueryFailure.InvalidFormat)
            value.length < SearchQuery.minLength -> Err(SearchQueryFailure.TooShort)
            else -> Ok(SearchQuery(value))
        }
    }

    private suspend fun searchStreamers(searchQuery: SearchQuery) = try {
        Ok(lateService.searchStreamers(searchQuery))
    } catch (error: LateServiceFailure) {
        Err(error)
    }
}

enum class SearchQueryFailure {
    Empty,
    InvalidFormat,
    TooShort,
}
