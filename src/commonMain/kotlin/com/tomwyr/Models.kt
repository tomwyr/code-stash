package com.tomwyr

import io.ktor.util.date.*
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
        val name: String,
        val imageUrl: String,
        val streamUrl: String,
)

@Serializable
data class LateInfo(
        val streamerInfo: StreamerInfo,
        val streamStatus: StreamStatus,
        val streamStart: Instant,
)

@Serializable
data class StreamerConfig(
        val id: StreamerId,
        val timeZone: TimeZone,
        val startTime: LocalTime,
        val offDays: OffDays,
)
