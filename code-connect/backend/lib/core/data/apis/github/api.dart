import 'package:code_connect_common/code_connect_common.dart';
import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

import '../../../../utils/env.dart';
import 'models.dart';

class GitHubApi {
  final _client = Dio(BaseOptions(
    baseUrl: 'https://api.github.com',
    headers: {
      'Authorization': Env.gitHubApiKey,
      'Content-Type': 'application/json',
    },
  ));

  Future<Result<List<User>, GitHubApiError>> searchUsers(String language, int limit) async {
    if (limit < 1 || limit > 5) {
      throw ArgumentError.value(limit);
    }

    final path = _buildSearchUsersPath(language, limit);
    final response = await _client.get(path);
    final data = response.body<SearchUsersData>();
    return data.items.toOk();
  }

  Future<Result<List<UserRepo>, GitHubApiError>> getUserLanguages(String login) async {
    final path = '/users/$login/repos';
    final response = await _client.get(path);
    return response.bodyList<UserRepo>().toOk();
  }

  String _buildSearchUsersPath(String language, int limit) {
    final usersPath = '/search/users';
    final query = 'language:$language type:User'.uriEncoded;
    final sort = 'sort=followers';
    final perPage = 'per_page=$limit';
    return '$usersPath?q=$query&$sort&$perPage';
  }
}

sealed class GitHubApiError {}
