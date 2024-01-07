package com.tomwyr.common

import kotlinx.browser.window
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.asCoroutineDispatcher
import kotlinx.coroutines.launch

val MainScope = CoroutineScope(window.asCoroutineDispatcher())

fun CoroutineScope.launchCatching(block: suspend CoroutineScope.() -> Unit) {
    try {
        launch { block() }
    } catch (throwable: Throwable) {
        console.log(throwable)
    }
}

