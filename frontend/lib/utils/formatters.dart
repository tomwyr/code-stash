import 'package:code_connect_common/code_connect_common.dart';

extension TeamCompositionDescription on TeamComposition {
  String describe() {
    final skills = roles.map((role) => role.describe()).join('\n\n');

    return '''
Team Composition:

[Description]
$projectDescription

[Roles]
$skills

'''
        .trimLeft();
  }
}

extension ProjectRoleDescription on ProjectRole {
  String describe() {
    return '''
Skill:  ${skill.language}
Name:   ${member.name}
Avatar: ${member.avatarUrl}
GitHub: ${member.profileUrl}
Stack:  ${member.skills.join()}
'''
        .trimLeft();
  }
}
