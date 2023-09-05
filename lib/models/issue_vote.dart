import 'package:json_annotation/json_annotation.dart';

part 'issue_vote.g.dart';

@JsonSerializable()
class IssueVote {
  IssueVote({
    required this.userId,
  });

  final String userId;

  factory IssueVote.fromJson(Map<String, dynamic> json) => _$IssueVoteFromJson(json);

  Map<String, dynamic> toJson() => _$IssueVoteToJson(this);
}
