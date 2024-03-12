import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final apiBaseUrl = dotenv.get('API_BASE_URL');
  static final projectRepoUrl = dotenv.get('PROJECT_REPO_URL');
}

Future<void> loadEnv() => dotenv.load(fileName: '.environment');
