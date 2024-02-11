package utils

import io.ktor.client.*
import io.ktor.client.engine.cio.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import kotlinx.coroutines.delay
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonObject
import kotlin.random.Random

object TopLanguages {
    private val client = HttpClient(CIO)

    suspend fun get(limit: Int): List<String> {
        require(limit in 1..100)

        return getRepoUrls(limit).flatMapIndexed { index, url ->
            if (index > 0) delayNextCall()
            getRepoLanguages(url)
        }.distinct()
    }

    private suspend fun getRepoUrls(limit: Int): List<String> {
        val url = "https://api.github.com/search/repositories?q=stars:%3E1&sort=stars&per_page=$limit"
        val json = client.get(url).bodyAsText()
        return extractLanguageUrls(json)
    }

    private fun extractLanguageUrls(reposJson: String): List<String> {
        val element = Json.parseToJsonElement(reposJson)
        val urls = ((element as JsonObject)["items"] as JsonArray)
                .map { item -> (item as JsonObject)["languages_url"] }
        return urls.mapNotNull { url -> url?.toString()?.trim('"') }
    }

    private suspend fun delayNextCall() {
        delay(Random.nextLong(300, 500))
    }

    private suspend fun getRepoLanguages(url: String): Iterable<String> {
        val response = client.get(url).bodyAsText()
        val repoLanguages = Json.parseToJsonElement(response) as JsonObject
        return repoLanguages.keys
    }
}
