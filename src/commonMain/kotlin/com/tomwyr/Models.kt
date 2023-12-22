package com.tomwyr

import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.serialization.Serializable
import kotlin.jvm.JvmInline

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
        val timeZone: TimeZone,
)

@Serializable
data class LateInfo(
        val streamerInfo: StreamerInfo,
        val streamStatus: StreamStatus,
        val streamStart: Instant,
)

@JvmInline
value class SemanticVersion(val value: String) {
    init {
        val pattern = Regex("^[0-9]+\\.[0-9]+\\.[0-9]+$")
        require(value.matches(pattern)) {
            "Value doesn't follow the semantic versioning pattern."
        }
    }
}
