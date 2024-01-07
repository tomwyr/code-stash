package com.tomwyr.common.utils

import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.isActive
import kotlin.time.Duration

fun periodicFlow(interval: Duration, eager: Boolean = false): Flow<Unit> = flow {
    if (eager) {
        emit(Unit)
        delay(interval)
    }
    while (currentCoroutineContext().isActive) {
        emit(Unit)
        delay(interval)
    }
}
