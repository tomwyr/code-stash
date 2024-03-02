import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

import '../error.dart';
import 'result_converter.dart';

class ResponseResult<S, F extends Object> {
  final converter = ResultConverter<S, F>();

  Future<Result<S, F>> convert(Future<Response> future) async {
    try {
      final response = await future;
      return convertResult(response, 200);
    } on DioException catch (error) {
      if (error.response case var response?) {
        return convertResult(response, 500);
      } else {
        rethrow;
      }
    }
  }

  Future<Result<S, F>> convertResult(Response response, int statusCode) async {
    if (response.statusCode != statusCode) {
      throw NotResultResponseError(Result<S, F>, response);
    }
    return converter.fromJson(response.data);
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
