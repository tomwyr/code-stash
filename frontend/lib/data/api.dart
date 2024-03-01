import 'package:code_connect_common/code_connect_common.dart';
import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

class CodeConnectApi {
  final _client = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
  ));

  Future<Result<TeamComposition, Error>> findTeam(String projectDescription) async {
    final input = FindTeamInput(projectDescription: projectDescription);
    final response = await _client.get('/team/find/', data: input.toJson());
    return response.body(TeamComposition.fromJson).toOk();
  }
}
