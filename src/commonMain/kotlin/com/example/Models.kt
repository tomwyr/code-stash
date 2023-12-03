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
data class LateInfo(
        val streamStatus: StreamStatus,
        val streamStart: Instant,
)
