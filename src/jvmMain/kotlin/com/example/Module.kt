package com.example

import com.example.services.LateService
import com.example.twitch.TwitchClient
import com.example.twitch.TwitchConfig
import com.example.utils.LocalStorage
import com.example.utils.createHttpClient
import org.koin.core.module.dsl.factoryOf
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module

val appModule = module {
    singleOf(TwitchConfig::fromYaml)
    single { get<TwitchConfig>().app }
    single { get<TwitchConfig>().streamer }
    single { createHttpClient() }
    singleOf(::LocalStorage)
    singleOf(::TwitchClient)
    factoryOf(::LateService)
}
