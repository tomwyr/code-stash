package com.tomwyr.common.extensions

import kotlinx.datetime.DayOfWeek

val DayOfWeek.displayName: String
    get() = name.lowercase().replaceFirstChar { it.uppercaseChar() }
