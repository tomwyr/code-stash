package utils

import io.github.cdimascio.dotenv.Dotenv

object Env {
    private val dotEnv = Dotenv.load()
    
    val openAiApiKey = dotEnv["OPENAI_API_KEY"]!!
    val gitHubApiKey = dotEnv["GITHUB_API_KEY"]!!
}
