package com.example

import com.example.stream.StreamView
import io.kvision.Application
import io.kvision.panel.root
import io.kvision.require

class App : Application() {
    init {
        require("css/kvapp.css")
    }

    override fun start(state: Map<String, Any>) {
        root("kvapp") {
            add(StreamView)
        }
    }
}
