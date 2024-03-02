import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

import '../error.dart';
import 'result_converter.dart';

class ResponseResult<S, F extends Object> {
  final converter = ResultConverter<S, F>();

  Future<Result<S, F>> convert(Future<Response> future) async {
    try {
      final response = await future;
      return _convertResult(response, 200);
    } on DioException catch (error) {
      final response = error.response;
      if (response == null || !_isErrResponse(response)) {
        rethrow;
      }
      return _convertResult(response, 500);
    }
  }

  bool _isErrResponse(Response response) {
    if (response.statusCode != 500) {
      return false;
    }

    final json = _jsonOrNull(response);
    if (json case {'type': 'ok' || 'err', 'data': Map<String, dynamic>()}) {
      return true;
    }

    return false;
  }

  Result<S, F> _convertResult(Response response, int statusCode) {
    if (response.statusCode != statusCode) {
      throw NotResultResponseError(Result<S, F>, response);
    }

    final json = jsonDecode(response.data);
    return converter.fromJson(json);
  }

  Map<String, dynamic>? _jsonOrNull(Response response) {
    try {
      return jsonDecode(response.data);
    } on FormatException {
      return null;
    }
  }
}

class NotResultResponseError extends Error with ErrorDetails<Response> {
  NotResultResponseError(this.type, this.details);

  final Type type;
  @override
  final Response details;

  @override
  String toString() {
    return 'An unexpected response was received for a request that was supposed '
        'to return $type data';
  }
}
