import 'package:dart_openai/dart_openai.dart';
import 'package:uuid/v4.dart';

extension type QueryId(String value) {
  static QueryId random() => QueryId(UuidV4().generate());
}

typedef ChatRole = OpenAIChatMessageRole;
typedef ChatMessage = OpenAIChatCompletionChoiceMessageModel;
typedef ChatMessageContent = OpenAIChatCompletionChoiceMessageContentItemModel;
typedef ChatCompletionChoice = OpenAIChatCompletionChoiceModel;

extension ChatCompletionChoiceAsText on ChatCompletionChoice {
  String? asText() => message.content?.join('\n');
}
