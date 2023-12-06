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
import kotlinx.coroutines.launch

object StreamModel {
    private val lateService = LateService()

    val lateInfo = ObservableValue<Result<LateInfo, LateServiceFailure>>(Loading)

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
