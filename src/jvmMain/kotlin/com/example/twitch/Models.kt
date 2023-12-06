package com.example.twitch

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
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
data class ListResponse<T>(
        val data: List<T>,
)

@Serializable
data class Stream(
        @SerialName("started_at") val startedAt: Instant,
)

@Serializable
data class Video(
        @SerialName("created_at") val createdAt: Instant,
        @Serializable(DurationSerializer::class) val duration: Duration,
)

@Serializable
enum class VideosSort {
    @SerialName("time")
    Time,

    @SerialName("trending")
    Trending,

    @SerialName("views")
    View;

    fun toJsonValue(): String {
        return Json.encodeToString(this).trim { it == '"' };
    }
}

@Serializable
enum class VideoType {
    @SerialName("all")
    All,

    @SerialName("archive")
    Archive,

    @SerialName("highlight")
    Highlight,

    @SerialName("upload")
    Upload;

    fun toJsonValue(): String {
        return Json.encodeToString(this).trim { it == '"' }
    }
}

@Serializable
data class User(
        val login: String,
        @SerialName("display_name") val displayName: String,
        @SerialName("profile_image_url") val profileImageUrl: String,
)
