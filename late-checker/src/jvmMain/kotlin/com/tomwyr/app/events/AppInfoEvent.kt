package com.tomwyr.app.events

import com.tomwyr.SearchQuery
import com.tomwyr.StreamerId

abstract class AppInfoEvent : AppEvent()

class LateInfoStale(streamerId: StreamerId) : AppInfoEvent() {
    override val message: String = "Cached late info for streamer id ${streamerId.value} is considered stale. Requesting fresh data from Twitch API."
}

class StreamersStale(searchQuery: SearchQuery) : AppInfoEvent() {
    override val message: String = "Cached streamers for query ${searchQuery.value} is considered stale. Requesting fresh data from Twitch API."
}

class AuthenticationRequired : AppInfoEvent() {
    override val message: String = "Access token is missing or no longer valid. Requesting fresh access token from Twitch API."
}
