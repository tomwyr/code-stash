package com.example.data

import com.example.models.types.Author
import com.example.utils.getRandomId

val authors by lazy {
    authorNames.map {
        Author(
            id = getRandomId(),
            name = it,
        )
    }.toMutableList()
}

private val authorNames = listOf(
    "Stephen King",
    "J.K. Rowling",
    "Amy Tan",
    "Khaled Hosseini",
    "Tana French",
    "George R.R Martin",
    "Danzy Senna",
    "Atul Gawande",
)
