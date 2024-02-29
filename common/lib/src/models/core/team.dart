import 'package:json_annotation/json_annotation.dart';

import 'tech_skill.dart';

part '../team.g.dart';

@JsonSerializable()
class TeamComposition {
  TeamComposition({
    required this.projectDescription,
    required this.roles,
  });

  final String projectDescription;
  final List<ProjectRole> roles;

  factory TeamComposition.fromJson(Map<String, dynamic> json) => _$TeamCompositionFromJson(json);
  Map<String, dynamic> toJson() => _$TeamCompositionToJson(this);
}

@JsonSerializable()
class ProjectRole {
  ProjectRole({
    required this.skill,
    required this.member,
  });

  final TechSkill skill;
  final TeamMember member;

  factory ProjectRole.fromJson(Map<String, dynamic> json) => _$ProjectRoleFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectRoleToJson(this);
}

@JsonSerializable()
class TeamMember {
  TeamMember({
    required this.name,
    required this.profileUrl,
    required this.avatarUrl,
    required this.skills,
  });

  final String name;
  final String profileUrl;
  final String avatarUrl;
  final List<TechSkill> skills;

  factory TeamMember.fromJson(Map<String, dynamic> json) => _$TeamMemberFromJson(json);
  Map<String, dynamic> toJson() => _$TeamMemberToJson(this);
}
