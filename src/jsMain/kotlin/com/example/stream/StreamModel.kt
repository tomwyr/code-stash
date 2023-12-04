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
import kotlinx.serialization.json.Json

object StreamModel {
    private val lateService = LateService()

    val lateInfo = ObservableValue<Result<LateInfo, LateServiceFailure>>(Loading)

    fun loadLateInfo() {
        MainScope.launch {
            try {
                val result = Json.decodeFromString<LateInfo>("{\"streamerInfo\":{\"name\":\"LIRIK\",\"imageUrl\":\"https://static-cdn.jtvnw.net/jtv_user_pictures/38e925fc-0b07-4e1e-82e2-6639e01344f3-profile_image-300x300.png\"},\"streamStatus\":\"Late\",\"streamStart\":\"2023-12-04T03:00:00Z\"}")
                lateInfo.value = Success(result)
                //                lateInfo.value = Success(lateService.getLateInfo())
            } catch (error: LateServiceFailure) {
                lateInfo.value = Failure(error)
            }
        }
    }
}
