package com.example.models.types

data class Book(
    val id: String,
    val title: String,
    val author: Author,
    val pages: List<Page>,
    val createdAt: String,
)
