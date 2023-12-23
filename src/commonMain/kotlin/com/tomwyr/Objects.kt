package com.tomwyr

import SemanticVersion

object AppInfo {
    val version = SemanticVersion("1.0.0")
}

object StreamUrl {
    operator fun invoke(login: String) = "https://twitch.tv/$login/"
}
