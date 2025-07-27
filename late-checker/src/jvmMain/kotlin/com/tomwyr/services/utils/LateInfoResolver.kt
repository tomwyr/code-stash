package com.tomwyr.services

import com.tomwyr.OffDays
import com.tomwyr.StreamStatus
import com.tomwyr.StreamerConfig
import com.tomwyr.twitch.Stream
import com.tomwyr.twitch.Video
import com.tomwyr.utils.extensions.intersects
import com.tomwyr.utils.now
import kotlinx.datetime.*
import kotlin.time.Duration
import kotlin.time.Duration.Companion.hours

interface StreamInfoResolver {
    companion object {
        fun create(config: StreamerConfig, currentStream: Stream?, newestVideo: Video?): StreamInfoResolver {
            return when (val completeConfig = CompleteStreamerConfig.from(config)) {
                null -> PartialStreamInfoResolver(currentStream)
                else -> CompleteStreamInfoResolver(completeConfig, currentStream, newestVideo)
            }
        }
    }

    fun getInfo(): Pair<StreamStatus, Instant?>
}

private class PartialStreamInfoResolver(
        val currentStream: Stream?,
) : StreamInfoResolver {
    override fun getInfo(): Pair<StreamStatus, Instant?> {
        return when {
            currentStream != null -> StreamStatus.Live to currentStream.startedAt
            else -> StreamStatus.Offline to null
        }
    }
}

private class CompleteStreamInfoResolver(
        private val config: CompleteStreamerConfig,
        private val currentStream: Stream?,
        private val newestVideo: Video?,
) : StreamInfoResolver {
    enum class StreamType(val timeMultiplier: Int) {
        Next(1),
        Last(-1),
    }

    private val maxDelay: Duration = 3.hours
    private val now: Instant = now()

    override fun getInfo(): Pair<StreamStatus, Instant?> {
        return when {
            currentStream != null -> StreamStatus.Live to currentStream.startedAt
            isLateStatus() -> StreamStatus.Late to getNearestStreamStart(StreamType.Last)
            else -> StreamStatus.Offline to getNearestStreamStart(StreamType.Next)
        }
    }

    private fun isLateStatus(): Boolean {
        return isNowInLateRange() && !wasOnlineInLateRange()
    }

    private fun isNowInLateRange(): Boolean {
        with(config) {
            val (dayOfWeek, currentDate) = now.toLocalDateTime(timeZone).let { it.dayOfWeek to it.date }
            val lateRange = currentDate.atTime(startTime).toInstant(timeZone).let { it..(it + maxDelay) }
            return dayOfWeek !in offDays && now in lateRange
        }
    }

    private fun wasOnlineInLateRange(): Boolean {
        if (newestVideo == null) return false

        val lateRange = now..(now + maxDelay)
        val videoRange = with(newestVideo) { createdAt..(createdAt + duration) }
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

private class CompleteStreamerConfig(
        val timeZone: TimeZone,
        val startTime: LocalTime,
        val offDays: OffDays,
) {
    companion object {
        fun from(streamerConfig: StreamerConfig) = with(streamerConfig) {
            if (timeZone != null && startTime != null) {
                CompleteStreamerConfig(timeZone, startTime, offDays ?: OffDays(listOf()))
            } else {
                null
            }
        }
    }
}

