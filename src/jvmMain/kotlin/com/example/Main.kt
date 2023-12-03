package com.example

import com.example.app.App
import io.ktor.server.application.*
import io.kvision.remote.kvisionInit

fun Application.main() {
    App.init(this)
    configurePlugins()
    kvisionInit(appModule)
}
