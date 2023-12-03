package com.example.services

import com.example.LateInfo
import com.example.StreamStatus
import com.example.twitch.Stream
import com.example.twitch.StreamerConfig
import com.example.twitch.TwitchClient
import com.example.twitch.Video
import com.github.michaelbull.result.getOrElse
import kotlinx.coroutines.delay
import kotlinx.datetime.*
import kotlinx.datetime.TimeZone.Companion.UTC
import kotlin.time.Duration
import kotlin.time.Duration.Companion.hours

@Suppress("ACTUAL_WITHOUT_EXPECT")
actual class LateService(
        private val streamerConfig: StreamerConfig,
        private val twitchClient: TwitchClient,
) : ILateService {
    override suspend fun getLateInfo(): LateInfo {
        throw CurrentStreamUnavailable()
        
        val currentStream = twitchClient.getCurrentStream(streamerConfig.id)
                .getOrElse { throw CurrentStreamUnavailable() }
        val newestVideo = twitchClient.getNewestVideo(streamerConfig.id)
                .getOrElse { throw NewestVideoUnavailable() }

        val (streamStatus, streamStart) =
                StreamInfoResolver(streamerConfig).getStatusAndStart(currentStream, newestVideo)

        return LateInfo(streamStatus, streamStart)
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
            val currentDate = now.toLocalDateTime(timeZone).date
            val weekDay = currentDate.dayOfWeek

            for (daysDiff in 0..7) {
                val nextDay = weekDay + daysDiff.toLong() * type.timeMultiplier
                if (nextDay in offDays) continue

                val nearestStartDate = currentDate + DatePeriod(days = daysDiff * type.timeMultiplier)
                return nearestStartDate.atTime(startTime).toInstant(UTC)
            }

            error("Could not calculate start of the nearest stream.")
        }
    }
}

fun <T : Comparable<T>> ClosedRange<T>.intersects(other: ClosedRange<T>): Boolean {
    return endInclusive >= other.start && start <= other.endInclusive
}
