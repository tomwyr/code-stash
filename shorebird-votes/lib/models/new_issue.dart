import 'package:json_annotation/json_annotation.dart';

part 'new_issue.g.dart';

@JsonSerializable()
class NewIssue {
  NewIssue({
    required this.title,
  });

  final String title;

  factory NewIssue.fromJson(Map<String, dynamic> json) =>
      _$NewIssueFromJson(json);

  Map<String, dynamic> toJson() => _$NewIssueToJson(this);
}
