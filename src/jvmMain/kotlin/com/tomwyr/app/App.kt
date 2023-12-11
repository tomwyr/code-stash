package com.tomwyr.app

import com.tomwyr.app.AppEvent.Type
import io.ktor.server.application.*
import io.ktor.util.logging.*

object App {
    private lateinit var application: Application

    private val log: Logger
        get() = application.log

    fun init(application: Application) {
        this.application = application
    }

    fun raise(event: AppEvent) {
        when (event.type) {
            Type.Error -> log.error(event.message)
        }
    }
}
