import 'package:code_connect_common/code_connect_common.dart';
import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

class CodeConnectApi {
  final _client = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
  ));

  Future<Result<TeamComposition, TeamFinderError>> find(String projectDescription) async {
    final input = FindTeamInput(projectDescription: projectDescription);
    final response = _client.get('/team/find/', data: input.toJson());
    return response.toResult<TeamComposition, TeamFinderError>();
  }
}
