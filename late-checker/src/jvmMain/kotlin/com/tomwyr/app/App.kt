package com.tomwyr.app

import com.tomwyr.app.events.AppErrorEvent
import com.tomwyr.app.events.AppEvent
import com.tomwyr.app.events.AppInfoEvent
import io.ktor.server.application.*
import io.ktor.util.logging.*

object App {
    private lateinit var log: Logger

    fun init(application: Application) {
        this.log = application.log
    }

    fun raise(event: AppEvent) {
        when (event) {
            is AppErrorEvent -> log.error(event.message)
            is AppInfoEvent -> log.info(event.message)
        }
    }
}
