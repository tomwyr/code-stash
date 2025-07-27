import 'package:code_connect_common/code_connect_common.dart';
import 'package:rust_core/result.dart';

import '../data/apis/github/api.dart';
import '../data/apis/openai/api.dart';
import '../data/mappers/team_member.dart';
import '../data/mappers/tech_skill.dart';
import 'queries.dart';

class TeamFinder {
  final _openAi = OpenAiApi();
  final _github = GitHubApi();

  Future<Result<TeamComposition, TeamFinderError>> find(String projectDescription) {
    return _getProjectSkills(projectDescription)
        .andThen(_searchTeam)
        .map((roles) => TeamComposition(projectDescription: projectDescription, roles: roles));
  }

  Future<Result<List<TechSkill>, TeamFinderError>> _getProjectSkills(
    String projectDescription,
  ) async {
    final queryId = _openAi.generateQueryId();
    final (techStackMsg, skillsMsg) = (Queries.techStack(projectDescription), Queries.skills);

    final answer = await _openAi
        .query(queryId, techStackMsg)
        .andThen((_) => _openAi.query(queryId, skillsMsg))
        .mapErr((_) => OpenAiServiceUnavailable());

    return answer.map(TechSkillMappers.fromOpenAiAnswer);
  }

  Future<Result<List<ProjectRole>, TeamFinderError>> _searchTeam(List<TechSkill> skills) {
    return skills.map(_getProjectRole).flatten().mapErr((_) => GitHubServiceUnavailable());
  }

  Future<Result<ProjectRole, GitHubApiError>> _getProjectRole(TechSkill skill) async {
    final gitHubData = await _github
        .searchUsers(skill.language, 1)
        .map((users) => users.single)
        .andThen((user) => _github.getUserLanguages(user.login).map((repos) => (user, repos)));

    return gitHubData.map((data) {
      final (user, repos) = data;
      final member = TeamMemberMappers.fromGitHub(user, repos);
      return ProjectRole(skill: skill, member: member);
    });
  }
}
