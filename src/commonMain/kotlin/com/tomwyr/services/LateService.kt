package com.tomwyr.services

import com.tomwyr.*
import io.kvision.annotations.KVService
import io.kvision.annotations.KVServiceException
import io.kvision.remote.AbstractServiceException
import kotlinx.serialization.Serializable

@KVService
interface ILateService {
    suspend fun getLateInfo(streamerConfig: StreamerConfig): LateInfo

    suspend fun searchStreamers(searchQuery: SearchQuery): List<StreamerInfo>
}

@Serializable
sealed class LateServiceFailure(override val message: String) : AbstractServiceException()

@KVServiceException
class StreamerNotFound(val streamerId: StreamerId) : LateServiceFailure("Streamer with given ID could not be found.")

@KVServiceException
class StreamerInfoUnavailable : LateServiceFailure("Unable to retrieve streamer info data. Please try again later.")

@KVServiceException
class CurrentStreamUnavailable : LateServiceFailure("Unable to retrieve current stream data. Please try again later.")

@KVServiceException
class NewestVideoUnavailable : LateServiceFailure("Unable to retrieve newest video data. Please try again later.")

@KVServiceException
class StreamersUnavailable : LateServiceFailure("Unable to retrieve streamers data. Please try again later.")