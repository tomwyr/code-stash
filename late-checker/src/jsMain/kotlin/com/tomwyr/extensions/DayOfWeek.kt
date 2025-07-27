package com.tomwyr.extensions

import kotlinx.datetime.DayOfWeek

val DayOfWeek.displayName: String
    get() = name.lowercase().replaceFirstChar { it.uppercaseChar() }
