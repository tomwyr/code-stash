package com.example.utils

import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.koin.core.annotation.Factory
import java.io.File

@Factory
class LocalStorage {
    companion object {
        private const val FILE_PATH = "db.json"
    }

    inline fun <reified T> read(key: String): T? {
        val content = getOrCreateFile().readText().let {
            Json.decodeFromString<Map<String, String>>(it)
        }

        return content[key]?.let { Json.decodeFromString(it) }
    }

    inline fun <reified T> write(key: String, value: T) {
        val file = getOrCreateFile()

        val content = file.readText().let {
            Json.decodeFromString<Map<String, String>>(it)
        }
        val newContent = content.toMutableMap().apply {
            set(key, Json.encodeToString<T>(value))
        }

        Json.encodeToString(newContent).let { file.writeText(it) }
    }

    fun delete(key: String) {
        val file = getOrCreateFile()

        val content = file.readText().let {
            Json.decodeFromString<Map<String, String>>(it)
        }
        val newContent = content.toMutableMap().apply {
            remove(key)
        }

        Json.encodeToString(newContent).let { file.writeText(it) }
    }

    fun getOrCreateFile(): File {
        val file = File(FILE_PATH)

        with(file) {
            if (!exists()) {
                val emptyContent = Json.encodeToString(mapOf<String, String>())
                createNewFile()
                writeText(emptyContent)
            }
        }

        return file
    }
}
