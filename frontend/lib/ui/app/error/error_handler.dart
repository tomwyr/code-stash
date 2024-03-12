import 'package:dio/dio.dart';

import '../../widgets/error_displayer.dart';

part 'texts.dart';

class AppErrorHandler {
  late DisplayError _displayError;

  void init(DisplayError displayError) {
    _displayError = displayError;
  }

  void call(Object error, StackTrace stackTrace) {
    final message = switch (error) {
      DioException(response: Response(statusCode: 500)) => _texts.serverError,
      _ => null,
    };

    if (message != null) {
      _displayError(message);
    }
  }
}
