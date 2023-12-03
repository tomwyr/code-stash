package com.example.app

import kotlin.reflect.KClass

interface AppEvent {
    enum class Type {
        Error,
    }

    val type: Type
    val message: String

    class DeserializationError(expectedClass: KClass<*>, body: String) : AppEvent {
        override val type: Type = Type.Error
        override val message: String = "Error while deserializing response data for type ${expectedClass.simpleName}. Received data was:\n$body"
    }
}

