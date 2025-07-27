package com.example.schema

import com.apurebase.kgraphql.schema.dsl.SchemaBuilder
import com.example.data.authors
import com.example.data.books
import com.example.models.inputs.AuthorInput
import com.example.models.inputs.BookInput
import com.example.models.types.Author
import com.example.models.types.Book
import com.example.models.types.Page
import com.example.utils.getRandomId
import io.ktor.http.*
import java.time.Instant

fun SchemaBuilder.configureMutations() {
    mutation("createAuthor") {
        description = "Creates new author from input"

        resolver { input: AuthorInput ->
            Author(
                id = getRandomId(),
                name = input.name,
            ).also(authors::add)
        }
    }

    mutation("createBook") {
        description = "Creates new book from input"

        resolver { input: BookInput ->
            Book(
                id = getRandomId(),
                title = input.title,
                author = authors.first { it.id == input.authorId },
                pages = input.pages.mapIndexed { index, pageInput ->
                    Page(
                        id = getRandomId(),
                        number = index + 1,
                        content = pageInput.content,
                    )
                },
                createdAt = Instant.now().toHttpDateString(),
            ).also(books::add)
        }
    }
}
