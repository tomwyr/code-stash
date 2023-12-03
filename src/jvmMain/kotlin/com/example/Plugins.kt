package com.example

import com.example.services.ILateService
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.plugins.compression.*
import io.ktor.server.plugins.defaultheaders.*
import io.ktor.server.routing.*
import io.kvision.remote.applyRoutes
import io.kvision.remote.getServiceManager

fun Application.configurePlugins() {
    install(Compression)
    install(DefaultHeaders)
    install(CallLogging)

    routing {
        applyRoutes(getServiceManager<ILateService>())
    }
}
