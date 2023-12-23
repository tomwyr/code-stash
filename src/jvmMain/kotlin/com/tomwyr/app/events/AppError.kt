package com.tomwyr.app.events

import io.ktor.client.statement.*
import io.ktor.http.*

abstract class AppError : AppEvent()

class CorruptedResponseBody(url: String, body: String, error: String) : AppError() {
    companion object {
        suspend operator fun invoke(response: HttpResponse, error: Throwable) = CorruptedResponseBody(
                url = response.request.url.toString(),
                body = response.bodyAsText(),
                error = error.toErrorMessage(),
        )
    }

    override val message: String = """
            |Error while deserializing response data for $url
            |Received body: $body
            |Underlying error: $error
            """.trimMargin()
}

class UnsuccessfulCall(url: String, status: HttpStatusCode, body: String) : AppError() {
    companion object {
        suspend operator fun invoke(response: HttpResponse) = UnsuccessfulCall(
                url = response.request.url.toString(),
                status = response.status,
                body = response.bodyAsText(),
        )
    }

    override val message: String = """
            |Http call failed with status $status
            |Requested url: $url
            |Received body: $body
        """.trimMargin()
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
