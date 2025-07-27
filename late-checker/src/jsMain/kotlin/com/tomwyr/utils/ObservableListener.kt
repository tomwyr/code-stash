package com.tomwyr.utils

import io.kvision.core.Component
import io.kvision.state.ObservableValue

fun <T> Component.addObservableListener(observable: ObservableValue<T>, listener: (T) -> Unit) {
    var unsubscribe: (() -> Unit)? = null

    addAfterInsertHook {
        unsubscribe = observable.subscribe { listener(it) }
    }

    addAfterDestroyHook {
        unsubscribe?.invoke()
    }
}

