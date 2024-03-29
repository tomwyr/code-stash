import 'package:code_connect_common/code_connect_common.dart';
import 'package:collection/collection.dart';

import '../apis/github/models.dart';
import 'tech_skill.dart';

class TeamMemberMappers {
  static TeamMember fromGitHub(User user, List<UserRepo> repos) {
    final skills = repos
        .map((repo) => repo.language?.let(TechSkillMappers.fromGitHubLanguage))
        .whereNotNull()
        .distinct()
        .toList();

    return TeamMember(
      name: user.login,
      profileUrl: user.htmlUrl,
      avatarUrl: user.avatarUrl,
      skills: skills,
    );
  }
}
