package data.apis

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import utils.Env
import java.net.URLEncoder

object GitHubApi {
    private val client = createClient()

    suspend fun searchUsers(language: String, limit: Int): List<User> {
        require(limit in 1..5)

        val url = buildSearchUsersUrl(language, limit)
        val data = client.get(url).body<SearchUsersData>()
        return data.items
    }

    suspend fun getUserLanguages(login: String): List<UserRepo> {
        val url = "https://api.github.com/users/$login/repos"
        return client.get(url).body<List<UserRepo>>()
    }

    private fun buildSearchUsersUrl(language: String, limit: Int): String {
        val usersUrl = "https://api.github.com/search/users"
        val query = "language:$language type:User".uriEncoded
        val sort = "sort=followers"
        val perPage = "per_page=$limit"
        return "$usersUrl?q=$query&$sort&$perPage"
    }

    @Serializable
    class SearchUsersData(
            val items: List<User>,
    )

    @Serializable
    class User(
            val login: String,
            @SerialName("avatar_url") val avatarUrl: String,
            @SerialName("html_url") val htmlUrl: String,
    )

    @Serializable
    class UserRepo(
            val language: String?,
    )

    sealed class Error {}
}

private fun createClient() = HttpClient(CIO) {
    install(DefaultRequest) {
        header("Authorization", Env.gitHubApiKey)
    }

    install(ContentNegotiation) {
        json(Json {
            prettyPrint = true
            ignoreUnknownKeys = true
        })
    }
}

private val String.uriEncoded
    get() = URLEncoder.encode(this, "UTF-8").replace("+", "%20")
