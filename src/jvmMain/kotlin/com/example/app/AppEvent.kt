package com.example.app

import io.ktor.client.statement.*
import io.ktor.http.*

interface AppEvent {
    enum class Type {
        Error,
    }

    val type: Type
    val message: String

    class DeserializationError private constructor(url: String, body: String, error: String) : AppEvent {
        companion object {
            suspend operator fun invoke(response: HttpResponse, error: Throwable): DeserializationError {
                return DeserializationError(
                        url = response.request.url.toString(),
                        body = response.bodyAsText(),
                        error = error.toErrorMessage(),
                )
            }
        }

        override val type: Type = Type.Error
        override val message: String = """
            |Error while deserializing response data for $url.
            |Received body: $body
            |Underlying error: $error
            """.trimMargin()
    }

    class UnsuccessfulCallError private constructor(url: String, status: HttpStatusCode, body: String) : AppEvent {
        companion object {
            suspend operator fun invoke(response: HttpResponse): UnsuccessfulCallError {
                return UnsuccessfulCallError(
                        url = response.request.url.toString(),
                        status = response.status,
                        body = response.bodyAsText(),
                )
            }
        }

        override val type: Type = Type.Error
        override val message: String = """
            |Http call failed with status $status.
            |Requested url: $url
            |Received body: $body
        """.trimMargin()
    }
}

private fun Throwable.toErrorMessage(): String {
    return StringBuilder().apply {
        message?.let { append(it) }
        cause?.let {
            if (isNotBlank()) append("\n")
            append(it.toErrorMessage())
        }
        if (isBlank()) append("<unknown>")
    }.toString()
}
