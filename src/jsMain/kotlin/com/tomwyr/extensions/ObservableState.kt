package com.tomwyr.common.extensions

import io.kvision.state.ObservableState
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow

fun <T> ObservableState<T>.asFlow(): Flow<T> {
    return callbackFlow {
        val unsubscribe = subscribe { trySend(it) }
        awaitClose { unsubscribe() }
    }
}
