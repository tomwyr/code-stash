package com.tomwyr.app.events

abstract class AppInfo : AppEvent()

class LateInfoStale : AppInfo() {
    override val message: String = "Requesting late info data from Twitch API."
}
