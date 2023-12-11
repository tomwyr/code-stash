package com.tomwyr.utils

import com.github.benmanes.caffeine.cache.Caffeine
import com.tomwyr.LateInfo
import kotlinx.coroutines.runBlocking
import org.koin.core.annotation.Single
import kotlin.time.toJavaDuration

@Single
class LateInfoCache {
    private val cache = Caffeine.newBuilder()
            .maximumSize(10L)
            .expireAfterWrite(CacheConfig.timeout.toJavaDuration())
            .build<String, LateInfo>()

    suspend fun getOr(compute: suspend () -> LateInfo): LateInfo {
        return cache.get("current") {
            runBlocking { compute() }
        } ?: error("LateInfo computation didn't return any value.")
    }
}
