import 'package:code_connect_common/code_connect_common.dart';
import 'package:dio/dio.dart';

import '../utils/env.dart';
import 'api_result.dart';

class CodeConnectApi {
  final _client = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
  ));

  ApiResult<TeamComposition> find(String projectDescription) async {
    final input = FindTeamInput(projectDescription: projectDescription);
    final response = _client.get('/team/find/', data: input.toJson());
    return response.toResult<TeamComposition, TeamFinderError>().toApiResult();
  }
}
