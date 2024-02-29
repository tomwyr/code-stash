import 'package:code_connect_common/code_connect_common.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/team_finder.dart';
import 'utils.dart';

part 'team_service.g.dart';

class TeamService {
  @Route.get('/team/find/')
  Future<Response> findTeam(Request request) async {
    final input = await request.body(FindTeamInput.fromJson);
    final result = await TeamFinder().find(input.projectDescription);
    return jsonOk(result);
  }

  Handler get handler => _$TeamServiceRouter(this).call;
}
