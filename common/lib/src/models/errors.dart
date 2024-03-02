import '../utils/sealed.dart';

sealed class TeamFinderError {
  TeamFinderError();

  factory TeamFinderError.fromJson(Map<String, dynamic> json) => switch (json['type']) {
        'GitHubServiceUnavailable' => GitHubServiceUnavailable(),
        'OpenAiServiceUnavailable' => OpenAiServiceUnavailable(),
        _ => throw UnexpectedSealedTypeError(TeamFinderError, json['type']),
      };

  Map<String, dynamic> toJson() => {
        'type': switch (this) {
          GitHubServiceUnavailable() => 'GitHubServiceUnavailable',
          OpenAiServiceUnavailable() => 'OpenAiServiceUnavailable',
        }
      };
}

class GitHubServiceUnavailable extends TeamFinderError {}

class OpenAiServiceUnavailable extends TeamFinderError {}
