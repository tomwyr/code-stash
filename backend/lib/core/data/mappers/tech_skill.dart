import 'package:code_connect_common/code_connect_common.dart';
import 'package:collection/collection.dart';

class TechSkillMappers {
  static List<TechSkill> fromOpenAiAnswer(String answer) {
    return TechSkill.values.where((skill) => answer.contains(skill.language)).toList();
  }

  static TechSkill? fromGitHubLanguage(String language) {
    return TechSkill.values.firstWhereOrNull((skill) => skill.language == language);
  }
}
