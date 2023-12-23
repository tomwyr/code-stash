package com.tomwyr.app.events

abstract class AppInfo : AppEvent()

class LateInfoStale : AppInfo() {
    override val message: String = "Cached late info is considered stale. Requesting fresh data from Twitch API."
}

class AuthenticationRequired : AppInfo() {
    override val message: String = "Access token is missing or no longer valid. Requesting fresh access token from Twitch API."
}
