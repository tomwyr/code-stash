import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final apiBaseUrl = dotenv.get('API_BASE_URL');
}

Future<void> loadEnv() => dotenv.load(fileName: '.environment');
