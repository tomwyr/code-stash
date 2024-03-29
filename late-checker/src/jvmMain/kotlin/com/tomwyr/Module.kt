package com.tomwyr

import com.tomwyr.twitch.TwitchAppConfig
import com.tomwyr.utils.AppHttpClient
import io.ktor.client.*
import org.koin.core.annotation.ComponentScan
import org.koin.core.annotation.Module
import org.koin.core.annotation.Single

@Module(includes = [ConfigModule::class, HttpModule::class])
@ComponentScan("com.tomwyr")
class AppModule

@Module
class ConfigModule {
    @Single
    fun twitchAppConfig(): TwitchAppConfig = TwitchAppConfig.fromYaml()
}

@Module
class HttpModule {
    @Single
    fun httpClient(): HttpClient = AppHttpClient.create()
}
