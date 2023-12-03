package com.example.app

import kotlin.reflect.KClass

interface AppEvent {
    enum class Type {
        Error,
    }

    val type: Type
    val message: String

    class DeserializationError<T : Any>(expectedClass: KClass<T>, body: String, error: Throwable) : AppEvent {
        override val type: Type = Type.Error
        override val message: String = """
            |Error while deserializing response data for type ${expectedClass.simpleName}.
            |Received data was: $body
            |Underlying error was: $error
            """.trimMargin()
    }
}
