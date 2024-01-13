package com.tomwyr

import kotlinx.datetime.Instant
import kotlinx.datetime.LocalTime
import kotlinx.datetime.TimeZone
import kotlinx.serialization.Serializable

@Serializable
enum class StreamStatus {
    Live,
    Late,
    Offline,
}

@Serializable
data class StreamerInfo(
        val id: StreamerId,
        val name: String,
        val imageUrl: String,
        val streamUrl: String,
)

@Serializable
data class LateInfo(
        val streamerInfo: StreamerInfo,
        val streamStatus: StreamStatus,
        val streamStart: Instant?,
)

@Serializable
data class StreamerConfig(
        val id: StreamerId,
        val timeZone: TimeZone? = null,
        val startTime: LocalTime? = null,
        val offDays: OffDays? = null,
)
