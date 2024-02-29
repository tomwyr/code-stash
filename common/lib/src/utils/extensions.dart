import 'dart:convert';

import 'package:dio/dio.dart';

extension ResponseBody on Response {
  T body<T>(T Function(Map<String, dynamic> json) fromJson) {
    return fromJson(jsonDecode(data));
  }

  List<T> bodyList<T>(T Function(Map<String, dynamic> json) fromJson) {
    return (jsonDecode(data) as List).cast<Map<String, dynamic>>().map(fromJson).toList();
  }
}

extension StringEncoder on String {
  String get uriEncoded {
    return Uri.encodeComponent(this).replaceAll('+', '%20');
  }
}
