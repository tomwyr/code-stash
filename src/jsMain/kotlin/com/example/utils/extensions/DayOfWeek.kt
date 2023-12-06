package com.example.utils.extensions

import io.ktor.util.date.*
import kotlinx.datetime.DayOfWeek

val DayOfWeek.shortName: String
    get() = WeekDay.from(this.ordinal).value
