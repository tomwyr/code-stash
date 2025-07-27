import 'package:dotenv/dotenv.dart';

class Env {
  static final port = _dotEnv['PORT']!;
  static final openAiApiKey = _dotEnv['OPENAI_API_KEY']!;
  static final gitHubApiKey = _dotEnv['GITHUB_API_KEY']!;
}

final _dotEnv = DotEnv(includePlatformEnvironment: true)..load();
