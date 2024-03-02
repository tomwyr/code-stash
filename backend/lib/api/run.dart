import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import '../utils/env.dart';
import 'team_service.dart';

Future<void> runApi() async {
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(TeamService().handler);
  await serve(handler, InternetAddress.anyIPv4, int.parse(Env.port));
}
