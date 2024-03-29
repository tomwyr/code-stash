package com.tomwyr.utils

import com.github.benmanes.caffeine.cache.Caffeine
import com.tomwyr.LateInfo
import com.tomwyr.SearchQuery
import com.tomwyr.StreamerId
import com.tomwyr.StreamerInfo
import kotlinx.coroutines.runBlocking
import org.koin.core.annotation.Single
import kotlin.time.Duration
import kotlin.time.Duration.Companion.hours
import kotlin.time.Duration.Companion.seconds
import kotlin.time.toJavaDuration

abstract class CacheOf<K, V>(
        expiration: Duration,
        val valueOf: (key: K) -> String,
) {
    private val cache = Caffeine.newBuilder()
            .maximumSize(1000L)
            .expireAfterWrite(expiration.toJavaDuration())
            .build<String, V>()

    suspend fun getOr(key: K, compute: suspend () -> V): V {
        return cache.get(valueOf(key)) {
            runBlocking { compute() }
        } ?: error("Value computation didn't return any value.")
    }
}

@Single
class LateInfoCache : CacheOf<StreamerId, LateInfo>(
        expiration = 30.seconds,
        valueOf = { it.value },
)

@Single
class StreamersCache : CacheOf<SearchQuery, List<StreamerInfo>>(
        expiration = 1.hours,
        valueOf = { it.value },
)
