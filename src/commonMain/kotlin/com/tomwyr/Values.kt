package com.tomwyr

import io.ktor.util.date.*
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
