package com.tomwyr.app.events

sealed class AppEvent {
    abstract val message: String
}
