package com.example.schema

import com.apurebase.kgraphql.schema.dsl.SchemaBuilder
import com.example.data.authors
import com.example.data.books

fun SchemaBuilder.configureQueries() {
    query("books") {
        description = "Retrieves list of all books"

        resolver { ->
            books
        }
    }

    query("authors") {
        description = "Retrieves list of all authors"

        resolver { ->
            authors
        }
    }

    query("authorOfBook") {
        description = "Retrieves author who has created given book"

        resolver { bookId: String ->
            books.first { it.id == bookId }.author
        }
    }

    query("pagesOfAuthor") {
        description = "Retrieves list of all pages written by given author"

        resolver { authorId: String, numberAtLeast: Int? ->
            books
                .filter { it.author.id == authorId }
                .flatMap { it.pages }
                .filter { numberAtLeast == null || it.number >= numberAtLeast }
        }
    }
}
