package com.tomwyr

import com.tomwyr.services.ILateService
import com.tomwyr.utils.CacheConfig
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.plugins.cachingheaders.*
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

    configureCaching()

    routing {
        applyRoutes(getServiceManager<ILateService>())
    }
}

fun Application.configureCaching() {
    install(CachingHeaders) {
        options { _, _ ->
            val maxAgeSeconds = CacheConfig.timeout.inWholeSeconds.toInt()
            CachingOptions(CacheControl.MaxAge(maxAgeSeconds))
        }
    }
}
