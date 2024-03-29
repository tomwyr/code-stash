package com.tomwyr.twitch

import com.charleskorn.kaml.Yaml
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString

@Serializable
data class TwitchAppConfig(
        val clientId: String,
        val secret: String,
) {
    companion object {
        fun fromYaml(): TwitchAppConfig {
            val inputStream = Companion::class.java.getResourceAsStream("/config.yaml")
            inputStream ?: error("Config file not found.")
            val yamlString = inputStream.bufferedReader().use { it.readText() }
            return Yaml.default.decodeFromString(yamlString)
        }
    }
}
