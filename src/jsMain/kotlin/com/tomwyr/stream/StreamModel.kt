package com.tomwyr.stream

import com.tomwyr.LateInfo
import com.tomwyr.MainScope
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.*
import io.kvision.state.ObservableValue
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlin.time.Duration.Companion.seconds

typealias LateInfoDataFlow = Flow<Result<LateInfo, LateServiceFailure>>

@OptIn(ExperimentalCoroutinesApi::class)
object StreamModel {
    private val lateService = LateService()

    private lateinit var lateInfoJob: Job

    val lateInfo = ObservableValue<Result<LateInfo, LateServiceFailure>>(Loading)
    val viewRefresh = ObservableValue(Any())

    fun initialize() {
        lateInfoJob = startLateInfoFlow()
    }

    fun retry() {
        lateInfoJob.cancel()
        lateInfoJob = startLateInfoFlow()
    }

    private fun startLateInfoFlow(): Job = MainScope.launch {
        periodicFlow(20.seconds, eager = true)
                .map { getLateInfo() }
                .onEach { lateInfo.value = it }
                .flatMapViewRefresh()
    }

    private suspend fun LateInfoDataFlow.flatMapViewRefresh() {
        flatMapLatest {
            when (it) {
                is Success -> periodicFlow(1.seconds)
                is Failure, Loading -> emptyFlow()
            }
        }.collect { viewRefresh.value = Any() }
    }

    private suspend fun getLateInfo() = try {
        console.log("get late info")
        Success(lateService.getLateInfo())
    } catch (error: LateServiceFailure) {
        Failure(error)
    }
}
