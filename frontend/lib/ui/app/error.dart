import 'package:dio/dio.dart';

import '../widgets/error_displayer.dart';

class AppErrorHandler {
  late DisplayError _displayError;

  void init(DisplayError displayError) {
    _displayError = displayError;
  }

  void call(Object error, StackTrace stackTrace) {
    final message = switch (error) {
      DioException() => _texts.genericError,
      _ => null,
    };

    if (message != null) {
      _displayError(message);
    }
  }
}

const _texts = (genericError: 'Something went wrong. Please try again in a few minutes.');
