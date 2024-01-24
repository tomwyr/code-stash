package com.example.data

import com.example.models.types.Book
import com.example.models.types.Page
import com.example.utils.getRandomId
import io.ktor.http.*
import java.time.Instant
import kotlin.random.Random

val books by lazy {
    bookTitles.map {
        Book(
            id = getRandomId(),
            title = it,
            author = authors.random(),
            pages = pageContents.filter { Random.nextBoolean() }.mapIndexed { index, content ->
                Page(
                    id = getRandomId(),
                    number = index + 1,
                    content = content,
                )
            },
            createdAt = Instant.now().minusSeconds(Random.nextLong(secondsInDecade)).toHttpDateString(),
        )
    }.toMutableList()
}

private const val secondsInDecade = 315360000L

private val bookTitles = listOf(
    "Ulysses",
    "The Great Gatsby",
    "A Portrait Of The Artist As A Young Man",
    "Lolita",
    "Brave New World",
    "The Sound And The Fury",
    "Catch-22",
    "Darkness At Noon",
    "Sons And Lovers",
    "The Grapes Of Wrath",
    "Under The Volcano",
    "The Way Of All Flesh",
    "1984",
    "I, Claudius",
    "To The Lighthouse",
    "An American Tragedy",
    "The Heart Is A Lonely Hunter",
    "Slaughterhouse-five",
    "Invisible Man",
    "Native Son",
)

private val pageContents = listOf(
    "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.",
    "Aenean et turpis vel magna condimentum condimentum a a augue.",
    "Cras ex ipsum, viverra ac convallis at, lacinia in tortor.",
    "Etiam varius erat et fermentum sagittis.",
    "Quisque sit amet urna sed nunc laoreet congue vel et ex.",
    "Fusce vel lobortis justo, faucibus maximus mi.",
    "Nulla pharetra elementum molestie.",
    "Proin pretium velit dui, ut porttitor ligula faucibus in.",
    "Suspendisse commodo malesuada porttitor.",
    "Vestibulum porta vel leo vitae varius.",
    "Etiam maximus laoreet turpis quis congue.",
    "Donec eu cursus massa, non consectetur massa.",
    "Praesent nulla eros, luctus non ex at, scelerisque ullamcorper lacus.",
    "Sed vestibulum erat ac purus facilisis, in ornare ante dapibus.",
    "Aliquam volutpat varius tincidunt.",
    "Vivamus ex nunc, laoreet sit amet tortor nec, ornare molestie orci.",
    "Sed tellus ex, ultrices nec libero id, fermentum commodo lectus.",
    "Quisque libero urna, ultricies ut dolor eu, venenatis malesuada urna.",
    "Donec elementum nec urna ac convallis.",
    "Donec ultricies porttitor mauris sed semper.",
)
