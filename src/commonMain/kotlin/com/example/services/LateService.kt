package com.example.services

import com.example.LateInfo
import io.kvision.annotations.KVService
import io.kvision.annotations.KVServiceException
import io.kvision.remote.AbstractServiceException
import kotlinx.serialization.Serializable

@KVService
interface ILateService {
    suspend fun getLateInfo(): LateInfo
}

@Serializable
sealed class LateServiceFailure(override val message: String) : AbstractServiceException()

@KVServiceException
class CurrentStreamUnavailable : LateServiceFailure("Unable to retrieve current stream data. Please try again later.")

@KVServiceException
class NewestVideoUnavailable : LateServiceFailure("Unable to retrieve newest video data. Please try again later.")
