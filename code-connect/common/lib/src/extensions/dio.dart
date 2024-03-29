import 'dart:convert';

import 'package:dio/dio.dart';

import '../utils/json/json.dart';

extension ResponseBody on Response {
  T body<T>() => _deserialize(data);

  List<T> bodyList<T>() {
    return switch (data) {
      List list => [
          for (data in list) _deserialize(data),
        ],
      _ => throw NotListDeserializableError(data, T),
    };
  }

  T _deserialize<T>(dynamic data) {
    final json = switch (data) {
      Map<String, dynamic>() => data,
      String() => jsonDecode(data),
      _ => throw NotDeserializableError(data, T),
    };
    return getFromJson<T>().call(json);
  }
}

class NotListDeserializableError extends Error {
  NotListDeserializableError(this.type, this.data);

  final Type type;
  final dynamic data;

  @override
  String toString() {
    return 'Json data must be List in order to be deserialized into a list of '
        'the request type $type (was ${data.runtimeType})';
  }
}

class NotDeserializableError extends Error {
  NotDeserializableError(this.type, this.data);

  final Type type;
  final dynamic data;

  @override
  String toString() {
    return 'Json data must be either String or Map<String, dynamic> in order '
        'to be deserialized into the requested type $type (was ${data.runtimeType})';
  }
}
