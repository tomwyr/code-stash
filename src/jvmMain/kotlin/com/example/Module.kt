package com.example

import com.example.twitch.AppConfig
import com.example.twitch.StreamerConfig
import com.example.twitch.TwitchConfig
import com.example.utils.AppHttpClient
import io.ktor.client.*
import org.koin.core.annotation.ComponentScan
import org.koin.core.annotation.Factory
import org.koin.core.annotation.Module
import org.koin.core.annotation.Single

@Module(includes = [ConfigModule::class, HttpModule::class])
@ComponentScan("com.example")
class AppModule

@Module
class ConfigModule {
    @Single
    fun twitchConfig(): TwitchConfig = TwitchConfig.fromYaml()

    @Factory
    fun appConfig(twitchConfig: TwitchConfig): AppConfig = twitchConfig.app

    @Factory
    fun streamerConfig(twitchConfig: TwitchConfig): StreamerConfig = twitchConfig.streamer
}

@Module
class HttpModule {
    @Single
    fun httpClient(): HttpClient = AppHttpClient.create()
}
