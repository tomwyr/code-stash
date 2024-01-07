package com.tomwyr.features.stream

import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.github.michaelbull.result.Result
import com.tomwyr.*
import com.tomwyr.StreamStatus.*
import com.tomwyr.common.MainScope
import com.tomwyr.common.launchCatching
import com.tomwyr.common.utils.periodicFlow
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.*
import io.kvision.state.ObservableValue
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.cancel
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*
import kotlinx.datetime.DayOfWeek
import kotlinx.datetime.LocalTime
import kotlinx.datetime.TimeZone
import kotlin.time.Duration
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

typealias LateInfoResult = Result<LateInfo, LateServiceFailure>

@OptIn(ExperimentalCoroutinesApi::class)
object StreamModel {
    private var initialized = false

    private val lateService = LateService()

    val version = ObservableValue(AppInfo.version.value)
    val repoUrl = ObservableValue(AppInfo.repoUrl)

    val lateInfo = ObservableValue<LateInfoResult?>(null)
    val viewRefresh = ObservableValue(Any())

    fun initialize() {
        if (!initialized) initialized = true else return

        startRefreshJob()
    }

    fun retry() {
        startRefreshJob()
    }

    private fun startRefreshJob() {
        MainScope.launchCatching {
            getLateInfoFlow()
                    .onEach { lateInfo.value = it }
                    .flatMapLatest { getViewRefreshFlow(it) }
                    .collect { viewRefresh.value = Any() }
        }
    }

    private fun getLateInfoFlow(): Flow<LateInfoResult> = flow {
        while (true) {
            val result = getLateInfo()

            emit(result)

            when (result) {
                is Ok -> delay(result.value.refreshInterval)
                is Err -> currentCoroutineContext().cancel()
            }
        }
    }

    private suspend fun getLateInfo() = try {
        val config = StreamerConfig(
                id = StreamerId("23161357"),
                startTime = LocalTime(12, 0),
                timeZone = TimeZone.of("America/New_York"),
                offDays = OffDays(listOf(DayOfWeek.THURSDAY))
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

