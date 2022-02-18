package com.example.schema

import com.apurebase.kgraphql.schema.dsl.SchemaBuilder
import com.example.models.inputs.AuthorInput
import com.example.models.inputs.BookInput
import com.example.models.inputs.PageInput
import com.example.models.types.Author
import com.example.models.types.Book
import com.example.models.types.Page

fun SchemaBuilder.configureTypes() {
    type<Book> {
        description = "Book with pages and author"
    }
    type<Author> {
        description = "Author of a book"
    }
    type<Page> {
        description = "Single page of a book"
    }

    inputType<BookInput> {
        description = "New book content"
    }
    inputType<AuthorInput> {
        description = "New author of a new book"
    }
    inputType<PageInput> {
        description = "New page of a new book"
    }
}
