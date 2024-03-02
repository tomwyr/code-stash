import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Env {
  static final _getVar = _getFromEnvironment();

  static final appPort = _getVar('APP_PORT');
  static final openAiApiKey = _getVar('OPENAI_API_KEY');
  static final gitHubApiKey = _getVar('GITHUB_API_KEY');
}

String Function(String key) _getFromEnvironment() {
  final isGlobe = Platform.environment.containsKey('GLOBE');
  if (isGlobe) {
    return (key) => Platform.environment[key]!;
  } else {
    final dotEnv = DotEnv()..load();
    return (key) => dotEnv[key]!;
  }
}
