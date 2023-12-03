package com.example

import io.ktor.server.application.*
import io.kvision.remote.kvisionInit

fun Application.main() {
    configurePlugins()
    kvisionInit(appModule)
}
