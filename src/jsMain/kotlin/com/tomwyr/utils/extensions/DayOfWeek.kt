package com.tomwyr.utils.extensions

import io.ktor.util.date.*
import kotlinx.datetime.DayOfWeek

val DayOfWeek.displayName: String
    get() = name.lowercase().replaceFirstChar { it.uppercaseChar() }
