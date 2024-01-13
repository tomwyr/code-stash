package com.tomwyr.features.stream

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.github.michaelbull.result.Result
import com.tomwyr.LateInfo
import com.tomwyr.StreamStatus.*
import com.tomwyr.StreamerConfig
import com.tomwyr.StreamerInfo
import com.tomwyr.data.StreamersStorage
import com.tomwyr.extensions.asFlow
import com.tomwyr.features.history.HistoryModel
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.services.StreamerNotFound
import com.tomwyr.utils.MainScope
import com.tomwyr.utils.launchCatching
import com.tomwyr.utils.now
import com.tomwyr.utils.periodicFlow
import io.kvision.state.ObservableValue
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.cancel
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*
import kotlin.time.Duration
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

typealias LateInfoResult = Result<LateInfo, LateServiceFailure>

sealed class LateInfoState {
    data object Initial : LateInfoState()
    data object Loading : LateInfoState()
    class Result(val result: LateInfoResult) : LateInfoState()
}

@OptIn(ExperimentalCoroutinesApi::class)
object StreamModel {
    private var initialized = false

    private val lateService = LateService()

    val selectedStreamer = ObservableValue<StreamerInfo?>(null)

    val lateInfo = ObservableValue<LateInfoState>(LateInfoState.Initial)
    val viewRefresh = ObservableValue(Any())

    fun initialize() {
        if (!initialized) initialized = true else return

        initSelectedStreamer()
        initHistoryNotifiers()
        startRefreshJob()
    }

    fun retry() {
        startRefreshJob()
    }

    private fun initSelectedStreamer() {
        StreamersStorage.loadAll().firstOrNull()?.let {
            selectedStreamer.value = it
        }
    }

    private fun initHistoryNotifiers() {
        MainScope.launchCatching {
            lateInfo.asFlow().mapNotNull { state ->
                ((state as? LateInfoState.Result)?.result as? Err)?.error as? StreamerNotFound
            }.collect {
                HistoryModel.onSelectedStreamerNotFound(it.streamerId)
            }
        }

        MainScope.launchCatching {
            selectedStreamer.asFlow().filterNotNull().collect {
                HistoryModel.onSelectedStreamerChanged(it)
            }
        }
    }

    private fun startRefreshJob() {
        MainScope.launchCatching {
            selectedStreamer.asFlow().filterNotNull()
                    .onEach { lateInfo.value = LateInfoState.Loading }
                    .flatMapLatest { getLateInfoFlow(it) }
                    .onEach { lateInfo.value = LateInfoState.Result(it) }
                    .flatMapLatest { getViewRefreshFlow(it) }
                    .collect { viewRefresh.value = Any() }
        }
    }

    private fun getLateInfoFlow(streamerInfo: StreamerInfo): Flow<LateInfoResult> = flow {
        while (true) {
            val result = getLateInfo(streamerInfo)

            emit(result)

            when (result) {
                is Ok -> delay(result.value.refreshInterval)
                is Err -> currentCoroutineContext().cancel()
            }
        }
    }

    private suspend fun getLateInfo(streamerInfo: StreamerInfo) = try {
        val config = StreamerConfig(
                id = streamerInfo.id,
                // startTime = LocalTime(12, 0),
                // timeZone = TimeZone.of("America/New_York"),
                // offDays = OffDays(listOf(DayOfWeek.THURSDAY))
        )

        Ok(lateService.getLateInfo(config))
    } catch (error: LateServiceFailure) {
        Err(error)
    }

    private fun getViewRefreshFlow(result: LateInfoResult): Flow<Unit> = when (result) {
        is Ok -> periodicFlow(1.seconds)
        is Err -> emptyFlow()
    }
}

private val LateInfo.refreshInterval: Duration
    get() {
        if (streamStart == null) {
            return 1.minutes
        }

        return when (streamStatus) {
            Live -> 1.minutes
            Late, Offline -> {
                val startAndNowMinutesDiff = streamStart.minus(now()).absoluteValue.inWholeMinutes.toInt()
                when (startAndNowMinutesDiff) {
                    0 -> 20.seconds
                    in 1..2 -> 1.minutes
                    in 3..5 -> 2.minutes
                    in 5..10 -> 3.minutes
                    else -> 5.minutes
                }
            }
        }
    }

