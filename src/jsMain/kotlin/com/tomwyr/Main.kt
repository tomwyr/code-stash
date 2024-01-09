package com.tomwyr

import io.kvision.CoreModule
import io.kvision.FontAwesomeModule
import io.kvision.module
import io.kvision.startApplication

fun main() {
    startApplication(::App, module.hot, CoreModule, FontAwesomeModule)
}
