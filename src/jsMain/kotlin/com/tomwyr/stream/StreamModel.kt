package com.tomwyr.stream

import com.tomwyr.LateInfo
import com.tomwyr.MainScope
import com.tomwyr.services.LateService
import com.tomwyr.services.LateServiceFailure
import com.tomwyr.utils.Failure
import com.tomwyr.utils.Loading
import com.tomwyr.utils.Result
import com.tomwyr.utils.Success
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
