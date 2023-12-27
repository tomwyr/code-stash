package com.tomwyr.utils.extensions

import com.tomwyr.utils.now
import kotlinx.datetime.Instant
import kotlinx.datetime.internal.JSJoda.DateTimeFormatter
import kotlinx.datetime.internal.JSJoda.ZoneId
import kotlin.time.Duration
import kotlinx.datetime.internal.JSJoda.Instant as JsInstant

@JsModule("@js-joda/timezone")
@JsNonModule
external object JsJodaTimeZoneModule

private val jsJodaTz = JsJodaTimeZoneModule

fun Instant.format(pattern: String, zoneId: String): String {
    val formatter = DateTimeFormatter.ofPattern(pattern)
    val dateTime = JsInstant.ofEpochSecond(epochSeconds.toDouble(), 0).atZone(ZoneId.of(zoneId))
    return formatter.format(dateTime)
}

fun Instant.untilNow(): Duration {
    val timePassed = now().minus(this)

    if (timePassed.isNegative()) {
        throw AssertionError("The given time is in the future.")
    }

    return timePassed
}

fun Instant.sinceNow(): Duration {
    val timePassed = this.minus(now())

    if (timePassed.isNegative()) {
        throw AssertionError("The given time is in the past.")
    }

    return timePassed
}
