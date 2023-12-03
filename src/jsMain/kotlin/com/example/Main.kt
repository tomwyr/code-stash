package com.example

import io.kvision.*
import kotlinx.browser.window
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.asCoroutineDispatcher

val MainScope = CoroutineScope(window.asCoroutineDispatcher())

fun main() {
    startApplication(::App, module.hot, BootstrapModule, FontAwesomeModule, CoreModule)
}
