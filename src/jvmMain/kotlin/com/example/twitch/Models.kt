package com.example.twitch

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.time.Duration

@Serializable
data class Session(
        @SerialName("access_token") val accessToken: String,
)

@Serializable
class CreateSessionInput(
        @SerialName("client_id") val clientId: String,
        @SerialName("client_secret") val clientSecret: String,
        @SerialName("grant_type") val grantType: String,
)

@Serializable
data class StreamsResponse(
        val data: List<Stream>,
)

@Serializable
data class VideosResponse(
        val data: List<Video>,
)

@Serializable
data class Stream(
        @SerialName("started_at") val startedAt: Instant,
)

@Serializable
data class Video(
        @SerialName("created_at") val createdAt: Instant,
        val duration: Duration,
)

@Serializable
enum class VideosSort {
    Time,
    Trending,
    Views,
}

@Serializable
enum class VideoType {
    All,
    Archive,
    Highlight,
    Upload,
}
