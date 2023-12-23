package com.tomwyr.stream

import com.tomwyr.AppInfo
import com.tomwyr.LateInfo
import com.tomwyr.MainScope
import com.tomwyr.StreamStatus.*
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.*
import io.kvision.state.ObservableValue
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.flow.*
import kotlin.time.Duration
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

typealias LateInfoResult = Result<LateInfo, LateServiceFailure>

@OptIn(ExperimentalCoroutinesApi::class)
object StreamModel {
    private val lateService = LateService()

    val version = ObservableValue(AppInfo.version.value)
    val lateInfo = ObservableValue<LateInfoResult?>(null)
    val viewRefresh = ObservableValue(Any())

    fun initialize() {
        startRefreshJob()
    }

    fun retry() {
        startRefreshJob()
    }

    private fun startRefreshJob() {
        MainScope.launch {
            getLateInfoFlow()
                    .onEach { lateInfo.value = it }
                    .flatMapLatest { getViewRefreshFlow(it) }
                    .collect { viewRefresh.value = Any() }
        }
    }

    private fun CoroutineScope.getLateInfoFlow(): Flow<LateInfoResult> = produce {
        while (isActive) {
            val result = getLateInfo()

            trySend(result)

            when (result) {
                is Success -> delay(result.value.refreshInterval)
                is Failure -> this@getLateInfoFlow.cancel()
            }
        }
    }.consumeAsFlow()

    private suspend fun getLateInfo() = try {
        Success(lateService.getLateInfo())
    } catch (error: LateServiceFailure) {
        Failure(error)
    }

    private fun getViewRefreshFlow(result: LateInfoResult): Flow<Unit> = when (result) {
        is Success -> periodicFlow(1.seconds)
        is Failure -> emptyFlow()
    }
}

private val LateInfo.refreshInterval: Duration
    get() = when (streamStatus) {
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

