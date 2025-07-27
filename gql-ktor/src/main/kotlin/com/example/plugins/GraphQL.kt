package com.example.plugins

import com.apurebase.kgraphql.GraphQL
import com.example.schema.configureMutations
import com.example.schema.configureQueries
import com.example.schema.configureTypes
import io.ktor.application.*

fun Application.configureGraphQL() {
    install(GraphQL) {
        schema {
            configureTypes()
            configureQueries()
            configureMutations()
        }
    }
}
