package com.tomwyr.twitch

import com.charleskorn.kaml.Yaml
import kotlinx.datetime.DayOfWeek
import kotlinx.datetime.LocalTime
import kotlinx.datetime.TimeZone
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString

@Serializable
data class TwitchConfig(
        val app: AppConfig,
        val streamer: StreamerConfig,
) {
    companion object {
        fun fromYaml(): TwitchConfig {
            val inputStream = Companion::class.java.getResourceAsStream("/config.yaml")
            inputStream ?: error("Config file not found.")
            val yamlString = inputStream.bufferedReader().use { it.readText() }
            return Yaml.default.decodeFromString(yamlString)
        }
    }
}

@Serializable
data class AppConfig(
        val clientId: String,
        val secret: String,
)

@Serializable
data class StreamerConfig(
        val id: String,
        val timeZone: TimeZone,
        val startTime: LocalTime,
        val offDays: OffDays,
)

@Serializable(OffDaysSerializer::class)
@JvmInline
value class OffDays(private val value: List<DayOfWeek>) : List<DayOfWeek> by value {
    init {
        require(toSet().size == size) {
            "Off days cannot have duplicates."
        }
        require(size < 7) {
            "There should be at least one stream day in a week."
        }
    }
}

