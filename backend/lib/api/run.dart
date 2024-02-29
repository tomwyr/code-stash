import 'package:shelf/shelf_io.dart';

import 'team_service.dart';

Future<void> runApi() async {
  await serve(TeamService().handler, 'localhost', 8080);
}
