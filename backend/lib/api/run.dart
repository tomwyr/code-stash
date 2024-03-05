import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_throttle/shelf_throttle.dart';
import 'package:time/time.dart';

import '../utils/env.dart';
import 'team_service.dart';

Future<void> runApi() async {
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(throttle(1.seconds))
      .addHandler(TeamService().handler);
  await serve(handler, InternetAddress.anyIPv4, int.parse(Env.port));
}
