package com.tomwyr

import com.tomwyr.app.App
import io.ktor.server.application.*
import io.kvision.remote.kvisionInit
import org.koin.ksp.generated.*

fun Application.main() {
    App.init(this)
    configurePlugins()
    kvisionInit(AppModule().module)
}
