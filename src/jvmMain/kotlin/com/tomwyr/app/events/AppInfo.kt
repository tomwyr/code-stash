package com.tomwyr.app.events

import io.ktor.client.statement.*

abstract class AppInfo : AppEvent()

class LateInfoStale : AppInfo() {
    override val message: String = "Cached late info is considered stale. Requesting fresh data from Twitch API"
}

class AuthenticationRequired : AppInfo() {
    override val message: String = "Requesting fresh access token from Twitch API"
}

class AuthenticationResult(val body: String) : AppInfo() {
    companion object {
        suspend operator fun invoke(response: HttpResponse) = AuthenticationResult(
                body = response.bodyAsText(),
        )
    }

    override val message: String = """
        |Received authentication call response from Twitch API
        |$body
        """.trimMargin()
}
