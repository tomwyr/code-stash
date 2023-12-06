package com.example.stream

import com.example.LateInfo
import com.example.MainScope
import com.example.services.LateService
import com.example.services.LateServiceFailure
import com.example.utils.Failure
import com.example.utils.Loading
import com.example.utils.Result
import com.example.utils.Success
import io.kvision.state.ObservableValue
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlin.time.Duration.Companion.seconds

object StreamModel {
    private val lateService = LateService()

    private var statusRefreshJob: Job? = null

    val lateInfo = ObservableValue<Result<LateInfo, LateServiceFailure>>(Loading)
    val refreshStatus = ObservableValue(Any())

    fun initialize() {
        startStatusRefresh()
        loadLateInfo()
    }

    private fun startStatusRefresh() {
        if (statusRefreshJob != null) return
        statusRefreshJob = MainScope.launch {
            while (isActive) {
                refreshStatus.value = Any()
                delay(1.seconds)
            }
        }
    }

    fun loadLateInfo() {
        MainScope.launch {
            try {
                lateInfo.value = Success(lateService.getLateInfo())
            } catch (error: LateServiceFailure) {
                lateInfo.value = Failure(error)
            }
        }
    }
}
