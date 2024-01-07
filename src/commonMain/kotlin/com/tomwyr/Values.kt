package com.tomwyr

import kotlinx.datetime.DayOfWeek
import kotlinx.serialization.Serializable
import kotlin.jvm.JvmInline

@JvmInline
value class SemanticVersion(val value: String) {
    init {
        val pattern = Regex("^[0-9]+\\.[0-9]+\\.[0-9]+$")
        require(value.matches(pattern)) {
            "$value doesn't follow the semantic versioning format."
        }
    }
}

@JvmInline
@Serializable
value class StreamerId(val value: String) {
    init {
        val pattern = Regex("^[0-9]+$")
        require(value.matches(pattern)) {
            "$value doesn't follow the Twitch streamer id format."
        }
    }
}

@JvmInline
@Serializable(OffDaysSerializer::class)
value class OffDays(val value: List<DayOfWeek>) {
    init {
        require(value.toSet().size == value.size) {
            "Off days cannot have duplicates."
        }
        require(value.size < 7) {
            "There should be at least one stream day in a week."
        }
    }

    operator fun contains(element: DayOfWeek): Boolean {
        return value.contains(element)
    }
}

@JvmInline
@Serializable
value class SearchQuery(val value: String) {
    companion object {
        val pattern = Regex("^[0-9a-zA-Z]*$")
        val minLength = 3
    }

    init {
        require(value.matches(pattern)) {
            "Search query can only be digits and letters (got $value)."
        }

        require(value.length >= minLength) {
            "Search query must be at least $minLength characters long."
        }
    }
}
