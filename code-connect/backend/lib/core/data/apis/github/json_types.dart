import 'package:code_connect_common/code_connect_common.dart';

import 'models.dart';

void registerGitHubJsonTypes() {
  addJsonType(SearchUsersData.fromJson);
  addJsonType(UserRepo.fromJson);
}
