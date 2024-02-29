import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  const baseUrl = 'http://localhost:8080';
  Uri uri(String path) => Uri.parse('$baseUrl$path');

  late Process process;

  setUp(() async {
    process = await Process.start(
      'dart',
      ['run', 'lib/main.dart'],
    );
  });

  tearDown(() => process.kill());

  test('find team returns data', () async {
    final response = await get(uri('/team/find/'));
    expect(response.statusCode, 200);
    expect(response.body, jsonEncode({'result': 5}));
  });
}
