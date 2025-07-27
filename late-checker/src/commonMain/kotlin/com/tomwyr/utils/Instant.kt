package com.tomwyr.utils

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone

fun now(): Instant = Clock.System.now()
fun here(): TimeZone = TimeZone.currentSystemDefault()
