package com.example.models.inputs

data class BookInput(
    val title: String,
    val authorId: String,
    val pages: List<PageInput>,
)
