package utils

import io.github.cdimascio.dotenv.Dotenv

object Env {
    private val dotEnv = Dotenv.load()
    
    val openAiApiKey = dotEnv["OPEN_AI_API_KEY"]
}
