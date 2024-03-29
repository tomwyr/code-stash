package com.tomwyr.features.common

import com.tomwyr.AppInfo
import io.kvision.state.ObservableValue

object AppModel {
    val version = ObservableValue(AppInfo.version.value)
    val repoUrl = ObservableValue(AppInfo.repoUrl)
}
