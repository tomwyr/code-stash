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
  Response toResponse() {
    final body = jsonEncode(ResultConverter().toJson(this));
    final statusCode = switch (this) {
      Ok() => HttpStatus.ok,
      Err() => HttpStatus.internalServerError,
    };
    return Response(statusCode, body: body);
  }
}
