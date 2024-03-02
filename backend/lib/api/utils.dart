import 'dart:convert';
import 'dart:io';

import 'package:code_connect_common/code_connect_common.dart';
import 'package:rust_core/result.dart';
import 'package:shelf/shelf.dart';

extension RequestBody on Request {
  Future<T> body<T>() async {
    final json = jsonDecode(await readAsString());
    return getFromJson<T>().call(json);
  }
}

extension ResultToResponse<S, F extends Object> on Result<S, F> {
  Response toResponse() => switch (this) {
        Ok(:var ok) => jsonResponse(HttpStatus.ok, ok),
        Err(:var err) => jsonResponse(HttpStatus.internalServerError, err),
      };
}

Response jsonResponse(int statusCode, dynamic body) {
  return Response(statusCode, body: jsonEncode(body.toJson()));
}
