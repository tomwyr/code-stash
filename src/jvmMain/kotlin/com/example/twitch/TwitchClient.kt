package com.example.twitch

import com.example.app.App
import com.example.app.AppEvent.DeserializationError
import com.example.utils.LocalStorage
import com.github.michaelbull.result.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*

class TwitchClient(
        private val config: AppConfig,
        private val client: HttpClient,
        private val localStorage: LocalStorage,
) {
    companion object {
        private const val AUTH_URL = "https://id.twitch.tv/oauth2/token"
        private const val AUTH_GRANT_TYPE = "client_credentials"

        private const val API_BASE_URL = "https://api.twitch.tv/helix"
        private const val STREAMS_URL = "$API_BASE_URL/streams"
        private const val VIDEOS_URL = "$API_BASE_URL/videos"
        private const val USERS_URL = "$API_BASE_URL/users"

        private const val SESSION_KEY = "session"
    }

    sealed class TwitchFailure {
        data object Unsuccessful : TwitchFailure()
        data object Unauthorized : TwitchFailure()
        data object InvalidResponse : TwitchFailure()
    }

    suspend fun getUser(id: String): Result<User?, TwitchFailure> {
        return getUsers(listOf(id)).map { it.data.singleOrNull() }
    }

    private suspend fun getUsers(ids: List<String>): Result<ListResponse<User>, TwitchFailure> {
        val idParams = ids.map { "id" to it }.toTypedArray()
        return query(USERS_URL, mapOf(*idParams))
    }


    suspend fun getCurrentStream(streamerId: String): Result<Stream?, TwitchFailure> {
        return getStreams(streamerId, first = 1).map { it.data.singleOrNull() }
    }

    private suspend fun getStreams(userLogin: String, first: Int?): Result<ListResponse<Stream>, TwitchFailure> {
        return query(STREAMS_URL, mapOf(
                "user_login" to userLogin,
                "first" to first,
        ))
    }

    suspend fun getNewestVideo(streamerId: String): Result<Video?, TwitchFailure> {
        return getVideos(streamerId, VideosSort.Time, VideoType.Archive, first = 1).map { it.data.firstOrNull() }
    }

    private suspend fun getVideos(
            userLogin: String,
            sort: VideosSort?,
            type: VideoType?,
            first: Int?,
    ): Result<ListResponse<Video>, TwitchFailure> {
        return query(VIDEOS_URL, mapOf(
                "user_login" to userLogin,
                "sort" to sort,
                "type" to type,
                "first" to first,
        ))
    }

    private suspend inline fun <reified T : Any> query(
            url: String,
            queryParams: Map<String, Any?>,
    ): Result<T, TwitchFailure> {
        return tryQuery<T>(url, queryParams).orElse {
            if (it is TwitchFailure.Unauthorized) {
                clearSession()
                tryQuery<T>(url, queryParams)
            } else {
                Err(it)
            }
        }
    }


    private suspend inline fun <reified T : Any> tryQuery(
            url: String,
            queryParams: Map<String, Any?>,
    ): Result<T, TwitchFailure> {
        val accessToken = authorize().accessToken
        val response = runQuery(url, queryParams, accessToken)

        return when (response.status.value) {
            in 200 until 300 -> {
                response.bodyOrNull<T>()?.let(::Ok) ?: Err(TwitchFailure.InvalidResponse)
            }

            400 -> Err(TwitchFailure.Unauthorized)
            else -> Err(TwitchFailure.Unsuccessful)
        }
    }

    private suspend fun runQuery(url: String, queryParams: Map<String, Any?>, accessToken: String): HttpResponse {
        return client.get {
            url(url)
            header("Client-Id", config.clientId)
            header("Authorization", "Bearer $accessToken")
            queryParams.forEach { (name, value) ->
                if (value != null) parameter(name, value)
            }
        }
    }

    private suspend fun authorize(): Session {
        val existingSession = localStorage.read<Session>(SESSION_KEY)
        return existingSession ?: run {
            createSession().also { localStorage.write(SESSION_KEY, it) }
        }
    }

    private fun clearSession() {
        localStorage.delete(SESSION_KEY)
    }

    private suspend fun createSession(): Session {
        val body = CreateSessionInput(
                clientId = config.clientId,
                clientSecret = config.secret,
                grantType = AUTH_GRANT_TYPE,
        )
        val response = client.post {
            url(AUTH_URL)
            setBody(body)
        }
        return response.body()
    }
}

suspend inline fun <reified T : Any> HttpResponse.bodyOrNull(): T? = try {
    body<T>()
} catch (error: Throwable) {
    App.raise(DeserializationError(T::class, bodyAsText(), error))
    null
}
