package com.tomwyr.services

import com.tomwyr.LateInfo
import com.tomwyr.StreamStatus
import com.tomwyr.StreamerInfo
import com.tomwyr.twitch.*
import com.github.michaelbull.result.getOrElse
import kotlinx.datetime.*
import org.koin.core.annotation.Factory
import kotlin.time.Duration
import kotlin.time.Duration.Companion.hours

@Suppress("ACTUAL_WITHOUT_EXPECT")
@Factory
actual class LateService(
        private val streamerConfig: StreamerConfig,
        private val twitchClient: TwitchClient,
) : ILateService {
    override suspend fun getLateInfo(): LateInfo {
        val userId = streamerConfig.id
        val user = twitchClient.getUser(userId)
                .getOrElse { throw StreamerInfoUnavailable() }
        val currentStream = twitchClient.getCurrentStream(userId)
                .getOrElse { throw CurrentStreamUnavailable() }
        val newestVideo = twitchClient.getNewestVideo(userId)
                .getOrElse { throw NewestVideoUnavailable() }

        val streamerInfo = user?.let(::getStreamerInfo) ?: throw StreamerNotFound()
        val (streamStatus, streamStart) =
                StreamInfoResolver(streamerConfig).getStatusAndStart(currentStream, newestVideo)

        return LateInfo(streamerInfo, streamStatus, streamStart)
    }

    private fun getStreamerInfo(user: User): StreamerInfo = with(user) {
        StreamerInfo(
                displayName,
                profileImageUrl,
                "https://twitch.tv/$login/",
                streamerConfig.timeZone,
        )
    }
}

private class StreamInfoResolver(
        private val streamerConfig: StreamerConfig,
        private val maxDelay: Duration = 3.hours,
        private val now: Instant = Clock.System.now(),
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
        with(streamerConfig) {
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
        with(streamerConfig) {
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

fun <T : Comparable<T>> ClosedRange<T>.intersects(other: ClosedRange<T>): Boolean {
    return endInclusive >= other.start && start <= other.endInclusive
}
