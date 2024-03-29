import 'package:dart_openai/dart_openai.dart';
import 'package:rust_core/result.dart';

import '../../../../utils/env.dart';
import 'models.dart';

class OpenAiApi {
  late final _client = _createClient();

  final _chatHistory = <QueryId, List<ChatMessage>>{};

  QueryId generateQueryId() {
    QueryId queryId;
    do {
      queryId = QueryId.random();
    } while (_chatHistory.containsKey(queryId));
    return queryId;
  }

  Future<Result<String, OpenAiApiError>> query(QueryId queryId, String message) async {
    final history = _chatHistory.putIfAbsent(queryId, () => []);
    final messages = [...history, _createChatMessage(message)];

    final completion = await _client.chat.create(model: 'gpt-3.5-turbo', messages: messages);
    final answer = completion.choices.map((choice) => choice.asText()).firstOrNull;

    if (answer != null) {
      _chatHistory[queryId] = messages;
      return answer.toOk();
    } else {
      return AnswerNotFound().toErr();
    }
  }

  ChatMessage _createChatMessage(String text) {
    return ChatMessage(
      role: ChatRole.user,
      content: [ChatMessageContent.text(text)],
    );
  }

  OpenAI _createClient() {
    OpenAI.apiKey = Env.openAiApiKey;
    OpenAI.instance.model.retrieve('gpt-3.5-turbo');
    return OpenAI.instance;
  }
}

sealed class OpenAiApiError {}

class AnswerNotFound extends OpenAiApiError {}
