package com.tomwyr.features.history

import com.tomwyr.StreamerId
import com.tomwyr.StreamerInfo
import com.tomwyr.features.stream.StreamModel
import io.kvision.state.ObservableValue

interface SelectedStreamerListener {
    fun onSelectedStreamerChanged(streamerInfo: StreamerInfo)
    fun onSelectedStreamerNotFound(streamerId: StreamerId)
}

object HistoryModel : SelectedStreamerListener {
    val streamers = ObservableValue<List<StreamerInfo>>(listOf())

    fun initialize() {
        loadStreamers()
    }

    fun onStreamerClick(streamerInfo: StreamerInfo) {
        StreamModel.selectedStreamer.value = streamerInfo
    }

    override fun onSelectedStreamerChanged(streamerInfo: StreamerInfo) {
        StreamersStorage.saveLatest(streamerInfo)
        loadStreamers()
    }

    override fun onSelectedStreamerNotFound(streamerId: StreamerId) {
        StreamersStorage.remove(streamerId)
        loadStreamers()
    }

    private fun loadStreamers() {
        streamers.value = StreamersStorage.loadAll()
    }
}
