import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final _getVar = dotenv.get;

  static Future<void> init() => dotenv.load();

  static final apiBaseUrl = _getVar('API_BASE_URL');
}
