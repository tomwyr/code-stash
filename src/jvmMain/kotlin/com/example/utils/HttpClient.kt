package com.example.utils

import com.example.services.CurrentStreamUnavailable
import com.example.services.NewestVideoUnavailable
import io.ktor.client.*
import io.ktor.client.engine.okhttp.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.kvision.remote.AbstractServiceException
import kotlinx.serialization.json.Json
import kotlinx.serialization.modules.SerializersModule
import kotlinx.serialization.modules.polymorphic

fun createHttpClient(): HttpClient {
    return HttpClient(OkHttp) {
        install(DefaultRequest) {
            contentType(ContentType.Application.Json)
            accept(ContentType.Application.Json)
        }
//        install(ContentNegotiation) {
//            json(Json {
//                prettyPrint = true
//                ignoreUnknownKeys = true
//                serializersModule = SerializersModule { 
//                    polymorphic(AbstractServiceException::class) {
//                        subclass(CurrentStreamUnavailable::class, CurrentStreamUnavailable.serializer())
//                        subclass(NewestVideoUnavailable::class, NewestVideoUnavailable.serializer())
//                    }
//                }
//            })
//        }
    }
}
