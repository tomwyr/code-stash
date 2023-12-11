package com.tomwyr.utils.extensions

import kotlinx.datetime.Clock
import kotlinx.datetime.internal.JSJoda.DateTimeFormatter
import kotlinx.datetime.internal.JSJoda.Instant
import kotlinx.datetime.internal.JSJoda.ZoneId
import kotlin.time.Duration

fun kotlinx.datetime.Instant.format(pattern: String, zoneId: String): String {
    val formatter = DateTimeFormatter.ofPattern(pattern)
    val dateTime = Instant.ofEpochSecond(epochSeconds).atZone(ZoneId.of(zoneId))
    return formatter.format(dateTime)
}

fun kotlinx.datetime.Instant.untilNow(): Duration {
    val now = Clock.System.now()
    val timePassed = now.minus(this)

    if (timePassed.isNegative()) {
        throw AssertionError("The given time is in the future.")
    }

    return timePassed
}

fun kotlinx.datetime.Instant.sinceNow(): Duration {
    val now = Clock.System.now()
    val timePassed = this.minus(now)

    if (timePassed.isNegative()) {
        throw AssertionError("The given time is in the past.")
    }

    return timePassed
}
