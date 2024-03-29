package com.tomwyr.extensions

import kotlin.time.Duration

fun Duration.formatHms(): String = toComponents { hours, minutes, seconds, _ ->
    var result = "${minutes.padded()}:${seconds.padded()}"
    if (hours > 0) {
        result = "${hours.padded()}:$result"
    }
    return result
}

private fun Number.padded(): String = toString().padStart(2, '0')
