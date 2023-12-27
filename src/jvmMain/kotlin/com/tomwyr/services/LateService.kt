package com.tomwyr.services

import com.github.michaelbull.result.getOrElse
import com.tomwyr.*
import com.tomwyr.app.App
import com.tomwyr.app.events.LateInfoStale
import com.tomwyr.twitch.Stream
import com.tomwyr.twitch.TwitchClient
import com.tomwyr.twitch.User
import com.tomwyr.twitch.Video
import com.tomwyr.utils.LateInfoCache
import com.tomwyr.utils.extensions.intersects
import com.tomwyr.utils.now
import kotlinx.datetime.*
import org.koin.core.annotation.Factory
import kotlin.time.Duration
import kotlin.time.Duration.Companion.hours

@Suppress("ACTUAL_WITHOUT_EXPECT")
@Factory
actual class LateService(
        private val lateInfoCache: LateInfoCache,
        private val twitchClient: TwitchClient,
) : ILateService {
    override suspend fun getLateInfo(config: StreamerConfig): LateInfo {
        val streamerId = config.id

        return lateInfoCache.getOr(streamerId) {
            App.raise(LateInfoStale(streamerId))
            resolveLateInfo(config, fetchLateInfoData(streamerId))
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

        val streamerInfo = user?.toStreamerInfo() ?: throw StreamerNotFound()
        val (streamStatus, streamStart) =
                StreamInfoResolver(config).getStatusAndStart(currentStream, newestVideo)
        return LateInfo(streamerInfo, streamStatus, streamStart)
    }
}

private typealias LateInfoData = Triple<User?, Stream?, Video?>

private fun User.toStreamerInfo() = StreamerInfo(
        displayName,
        profileImageUrl,
        StreamUrl(login),
)

private class StreamInfoResolver(
        private val config: StreamerConfig,
        private val maxDelay: Duration = 3.hours,
        private val now: Instant = now(),
) {
    enum class StreamType(val timeMultiplier: Int) {
        Next(1),
        Last(-1),
    }


    fun getStatusAndStart(currentStream: Stream?, newestVideo: Video?): Pair<StreamStatus, Instant> {
        return when {
            currentStream != null -> StreamStatus.Live to currentStream.startedAt
            isNowInLateRange() && !wasOnlineInLateRange(newestVideo) -> StreamStatus.Late to getNearestStreamStart(StreamType.Last)
            else -> StreamStatus.Offline to getNearestStreamStart(StreamType.Next)
        }
    }

    private fun isNowInLateRange(): Boolean {
        with(config) {
            val (dayOfWeek, currentDate) = now.toLocalDateTime(timeZone).let { it.dayOfWeek to it.date }
            val lateRange = currentDate.atTime(startTime).toInstant(timeZone).let { it..(it + maxDelay) }
            return dayOfWeek !in offDays && now in lateRange
        }
    }

    private fun wasOnlineInLateRange(video: Video?): Boolean {
        if (video == null) return false

        val lateRange = now..(now + maxDelay)
        val videoRange = with(video) { createdAt..(createdAt + duration) }
        return lateRange.intersects(videoRange)
    }

    private fun getNearestStreamStart(type: StreamType): Instant {
        with(config) {
            val (currentDate, currentTime) = now.toLocalDateTime(timeZone).run { date to time }
            val weekDay = currentDate.dayOfWeek
            val skipToday = when (type) {
                StreamType.Next -> currentTime >= startTime
                StreamType.Last -> currentTime <= startTime
            }

            for (daysDiff in 0..7) {
                if (daysDiff == 0 && skipToday) continue

                val nextDay = weekDay + daysDiff.toLong() * type.timeMultiplier
                if (nextDay in offDays) continue

                val nearestStartDate = currentDate + DatePeriod(days = daysDiff * type.timeMultiplier)
                return nearestStartDate.atTime(startTime).toInstant(timeZone)
            }

            error("Could not calculate start of the nearest stream.")
        }
    }
}
