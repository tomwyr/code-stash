package data

import com.aallam.openai.api.chat.ChatCompletionRequest
import com.aallam.openai.api.chat.ChatMessage
import com.aallam.openai.api.chat.ChatResponseFormat
import com.aallam.openai.api.model.ModelId
import com.aallam.openai.client.OpenAI
import com.github.michaelbull.result.Err
import com.github.michaelbull.result.Ok
import com.github.michaelbull.result.Result
import data.OpenAiClient.Error.AnswerNotFound
import data.OpenAiClient.Error.UnknownQuery
import utils.Env
import java.util.*

@JvmInline
value class QueryId(val value: String) {
    companion object {
        fun random(): QueryId = QueryId(UUID.randomUUID().toString())
    }
}

object OpenAiClient {
    private val client = OpenAI(Env.openAiApiKey)
    private val model = ModelId("gpt-3.5-turbo")

    private val chatHistory: MutableMap<QueryId, List<ChatMessage>> = mutableMapOf()

    fun generateQueryId(): QueryId {
        var queryId: QueryId
        do {
            queryId = QueryId.random()
        } while (chatHistory.containsKey(queryId))
        return queryId
    }

    suspend fun query(queryId: QueryId, message: String): Result<String, Error> {
        val history = chatHistory[queryId] ?: return Err(UnknownQuery)
        val messages = history + ChatMessage.User(message)

        val completion = client.chatCompletion(
                ChatCompletionRequest(
                        model = model,
                        messages = messages,
                        responseFormat = ChatResponseFormat.JsonObject,
                )
        )
        val answer = completion.choices.firstNotNullOfOrNull { choice -> choice.message.content }

        if (answer != null) {
            chatHistory[queryId] = messages
            return Ok(answer)
        } else {
            return Err(AnswerNotFound)
        }
    }

    sealed class Error {
        data object UnknownQuery : Error()
        data object AnswerNotFound : Error()
    }
}
