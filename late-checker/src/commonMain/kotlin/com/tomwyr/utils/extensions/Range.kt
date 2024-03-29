package com.tomwyr.utils.extensions

fun <T : Comparable<T>> ClosedRange<T>.intersects(other: ClosedRange<T>): Boolean {
    return endInclusive >= other.start && start <= other.endInclusive
}
