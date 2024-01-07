package com.tomwyr.features.search

import com.tomwyr.SearchQuery
import com.tomwyr.StreamerInfo
import com.tomwyr.common.MainScope
import com.tomwyr.common.launchCatching
import com.tomwyr.common.utils.Failure
import com.tomwyr.common.utils.Result
import com.tomwyr.common.utils.Success
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.common.extensions.asFlow
import io.kvision.state.ObservableValue
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.*
import kotlin.time.Duration.Companion.seconds

typealias StreamersResult = Result<List<StreamerInfo>, LateServiceFailure>
typealias SearchQueryResult = Result<SearchQuery, SearchQueryFailure>

@OptIn(FlowPreview::class, ExperimentalCoroutinesApi::class)
object StreamerSearchModel {
    private var initialized = false

    private val lateService = LateService()

    val searchQueryInput = ObservableValue("")

    val searchQuery = ObservableValue(processInput(""))

    val streamers = ObservableValue<StreamersResult?>(null)

    fun initialize() {
        if (!initialized) initialized = true else return

        MainScope.launchCatching {
            getSearchQueryFlow().collectLatest { searchQuery.value = it }
        }

        MainScope.launchCatching {
            getSearchQueryFlow().mapNotNull { it as? Success }
                    .mapLatest { searchStreamers(it.value) }
                    .collect { streamers.value = it }
        }
    }

    private fun getSearchQueryFlow(): Flow<SearchQueryResult> {
        return searchQueryInput.asFlow().distinctUntilChanged().debounce(1.seconds).map {
            processInput(it).also {
                console.log(it)
            }
        }
    }

    private fun processInput(input: String): SearchQueryResult {
        val value = input.replace(" ", "")

        return when {
            value.isEmpty() -> Failure(SearchQueryFailure.Empty)
            !value.matches(SearchQuery.pattern) -> Failure(SearchQueryFailure.InvalidFormat)
            value.length < SearchQuery.minLength -> Failure(SearchQueryFailure.TooShort)
            else -> Success(SearchQuery(value))
        }
    }

    private suspend fun searchStreamers(searchQuery: SearchQuery) = try {
        Success(lateService.searchStreamers(searchQuery))
    } catch (error: LateServiceFailure) {
        Failure(error)
    }
}

enum class SearchQueryFailure {
    Empty,
    InvalidFormat,
    TooShort,
}
