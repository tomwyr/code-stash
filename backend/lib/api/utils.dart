import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

extension RequestBody on Request {
  Future<T> body<T>(T Function(Map<String, dynamic> json) fromJson) async {
    return fromJson(jsonDecode(await readAsString()));
  }
}

Response jsonOk(dynamic body) => jsonResponse(HttpStatus.ok, body);

Response jsonResponse(int statusCode, dynamic body) {
  return Response(statusCode, body: jsonEncode(body.toJson()));
}
