import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data/appwrite.dart';
import '../data/issue_vote_converter.dart';
import 'issue_vote.dart';

part 'issue.g.dart';

@CopyWith()
@JsonSerializable()
class Issue {
  Issue({
    required this.id,
    required this.title,
    required this.votes,
  });

  @idKey
  final String id;
  final String title;
  @IssueVoteConverter()
  final List<IssueVote> votes;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);

  Map<String, dynamic> toJson() => _$IssueToJson(this);
}
