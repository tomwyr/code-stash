package com.tomwyr.utils

import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

fun now(): Instant = Clock.System.now()
