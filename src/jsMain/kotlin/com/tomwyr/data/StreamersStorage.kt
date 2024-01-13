package com.tomwyr.features.history

import com.tomwyr.StreamerId
import com.tomwyr.StreamerInfo
import kotlinx.browser.localStorage
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.w3c.dom.get
import org.w3c.dom.set

object StreamersStorage {
    private const val key = "streamers"
    private const val maxCount = 5


    fun loadAll(): List<StreamerInfo> {
        val data = localStorage[key] ?: ""
        return try {
            Json.decodeFromString<List<StreamerInfo>>(data)
        } catch (error: Throwable) {
            listOf()
        }
    }

    fun saveLatest(streamerInfo: StreamerInfo) {
        modifyAndSave {
            val otherStreamers = filter { it.id != streamerInfo.id }
            listOf(streamerInfo).plus(otherStreamers).take(maxCount)
        }
    }

    fun remove(streamerId: StreamerId) {
        modifyAndSave {
            filter { it.id != streamerId }
        }
    }

    private fun modifyAndSave(block: List<StreamerInfo>.() -> List<StreamerInfo>?) {
        val streamers = loadAll().let(block) ?: return
        val data = Json.encodeToString(streamers)
        localStorage[key] = data
    }
}
