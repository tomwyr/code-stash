package com.example

import kotlinx.datetime.Instant
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
)

@Serializable
data class LateInfo(
        val streamerInfo: StreamerInfo,
        val streamStatus: StreamStatus,
        val streamStart: Instant,
)
