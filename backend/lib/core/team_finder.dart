import 'package:code_connect_common/code_connect_common.dart';
import 'package:rust_core/result.dart';

import 'data/apis/github/api.dart';
import 'data/apis/openai/api.dart';
import 'data/mappers/team_member.dart';
import 'data/mappers/tech_skill.dart';

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
    final message = techQuery(projectDescription);
    final answer =
        await _openAi.query(queryId, message).andThen((_) => _openAi.query(queryId, skillsQuery));
    return answer.map(TechSkillMappers.fromOpenAiAnswer).mapErr((_) => FindingFailed());
  }

  Future<Result<List<ProjectRole>, TeamFinderError>> _searchTeam(List<TechSkill> skills) async {
    final roles = await skills.map((skill) async {
      final user = (await _github.searchUsers(skill.language, 1)).single;
      final repos = await _github.getUserLanguages(user.login);
      final member = TeamMemberMappers.fromGitHub(user, repos);
      return ProjectRole(skill: skill, member: member);
    }).wait;

    return Ok(roles);
  }
}

sealed class TeamFinderError {}

class FindingFailed extends TeamFinderError {}

String techQuery(String projectDescription) => '''
What tech stack would be best to develop the following application:
$projectDescription
'''
    .trim();

final skillsQuery = '''
|What programming languages would be needed to use this tech stack. List the languages separated by comma.
'''
    .trim();
