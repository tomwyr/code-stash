import 'package:code_connect_common/code_connect_common.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../core/finder/team_finder.dart';
import 'extensions.dart';

part 'team_service.g.dart';

class TeamService {
  @Route.post('/team/find/')
  Future<Response> findTeam(Request request) async {
    final input = await request.body<FindTeamInput>();
    final result = await TeamFinder().find(input.projectDescription);
    return result.toResponse();
  }

  Handler get handler => _$TeamServiceRouter(this).call;
}
