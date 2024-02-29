import 'package:json_annotation/json_annotation.dart';

part 'inputs.g.dart';

@JsonSerializable()
class FindTeamInput {
  FindTeamInput({required this.projectDescription});

  final String projectDescription;

  factory FindTeamInput.fromJson(Map<String, dynamic> json) => _$FindTeamInputFromJson(json);
  Map<String, dynamic> toJson() => _$FindTeamInputToJson(this);
}
