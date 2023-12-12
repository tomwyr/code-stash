package com.tomwyr.app

import com.tomwyr.app.events.AppError
import com.tomwyr.app.events.AppEvent
import com.tomwyr.app.events.AppInfo
import io.ktor.server.application.*
import io.ktor.util.logging.*

object App {
    private lateinit var log: Logger

    fun init(application: Application) {
        this.log = application.log
    }

    fun raise(event: AppEvent) {
        when (event) {
            is AppError -> log.error(event.message)
            is AppInfo -> log.info(event.message)
        }
    }
}
