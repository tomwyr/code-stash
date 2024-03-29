package com.tomwyr.services

import com.github.michaelbull.result.getOrElse
import com.tomwyr.*
import com.tomwyr.app.App
import com.tomwyr.app.events.LateInfoStale
import com.tomwyr.app.events.StreamersStale
import com.tomwyr.twitch.*
import com.tomwyr.utils.LateInfoCache
import com.tomwyr.utils.StreamersCache
import org.koin.core.annotation.Factory

@Suppress("ACTUAL_WITHOUT_EXPECT")
@Factory
actual class LateService(
        private val lateInfoCache: LateInfoCache,
        private val streamersCache: StreamersCache,
        private val twitchClient: TwitchClient,
) : ILateService {
    override suspend fun getLateInfo(streamerConfig: StreamerConfig): LateInfo {
        val streamerId = streamerConfig.id

        return lateInfoCache.getOr(streamerId) {
            App.raise(LateInfoStale(streamerId))
            resolveLateInfo(streamerConfig, fetchLateInfoData(streamerId))
        }
    }

    override suspend fun searchStreamers(searchQuery: SearchQuery): List<StreamerInfo> {
        return streamersCache.getOr(searchQuery) {
            App.raise(StreamersStale(searchQuery))
            val response = twitchClient.searchChannels(searchQuery.value, 10).getOrElse { throw StreamersUnavailable() }
            response.data.map { it.toStreamerInfo() }
        }
    }

    private suspend fun fetchLateInfoData(streamerId: StreamerId): LateInfoData {
        val userId = streamerId.value

        val user = twitchClient.getUser(userId)
                .getOrElse { throw StreamerInfoUnavailable() }
        val currentStream = twitchClient.getCurrentStream(userId)
                .getOrElse { throw CurrentStreamUnavailable() }
        val newestVideo = twitchClient.getNewestVideo(userId)
                .getOrElse { throw NewestVideoUnavailable() }

        return Triple(user, currentStream, newestVideo)
    }

    private fun resolveLateInfo(config: StreamerConfig, data: LateInfoData): LateInfo {
        val (user, currentStream, newestVideo) = data

        val streamerInfo = user?.toStreamerInfo() ?: throw StreamerNotFound(config.id)
        val (streamStatus, streamStart) = StreamInfoResolver.create(config, currentStream, newestVideo).getInfo()
        return LateInfo(streamerInfo, streamStatus, streamStart)
    }
}

private typealias LateInfoData = Triple<User?, Stream?, Video?>

private fun User.toStreamerInfo() = StreamerInfo(
        StreamerId(id),
        displayName,
        profileImageUrl,
        StreamUrl(login),
)

private fun Channel.toStreamerInfo() = StreamerInfo(
        StreamerId(id),
        displayName,
        thumbnailUrl,
        StreamUrl(broadcasterLogin),
)
