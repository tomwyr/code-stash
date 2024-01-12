package com.tomwyr.common

import io.kvision.core.Component
import kotlinx.browser.window
import org.w3c.dom.events.KeyboardEvent

typealias KeyCallback = (key: KeyboardEvent) -> Unit

object KeyListener {
    private val listeners: MutableSet<KeyCallback> = mutableSetOf()

    init {
        window.onkeydown = {
            for (listener in listeners.toList()) {
                listener(it)
            }
        }
    }

    fun onKey(listener: KeyCallback): () -> Unit {
        listeners.add(listener)
        return { listeners.remove(listener) }
    }
}

fun Component.addKeyListener(listener: KeyCallback) {
    var unsubscribe: (() -> Unit)? = null

    addAfterInsertHook {
        unsubscribe = KeyListener.onKey(listener)
    }

    addAfterDestroyHook {
        unsubscribe?.invoke()
    }
}
