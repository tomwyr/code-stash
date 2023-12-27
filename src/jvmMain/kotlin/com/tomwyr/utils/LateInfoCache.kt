package com.tomwyr.utils

import com.github.benmanes.caffeine.cache.Caffeine
import com.tomwyr.LateInfo
import com.tomwyr.StreamerId
import kotlinx.coroutines.runBlocking
import org.koin.core.annotation.Single
import kotlin.time.toJavaDuration

@Single
class LateInfoCache {
    private val cache = Caffeine.newBuilder()
            .maximumSize(1000L)
            .expireAfterWrite(CacheConfig.timeout.toJavaDuration())
            .build<String, LateInfo>()

    suspend fun getOr(streamerId: StreamerId, compute: suspend () -> LateInfo): LateInfo {
        return cache.get(streamerId.value) {
            runBlocking { compute() }
        } ?: error("LateInfo computation didn't return any value.")
    }
}
