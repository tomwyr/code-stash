import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../models/issue_vote.dart';

class IssueVoteConverter extends JsonConverter<IssueVote, String> {
  const IssueVoteConverter();

  @override
  IssueVote fromJson(String json) => IssueVote.fromJson(jsonDecode(json));

  @override
  String toJson(IssueVote object) => jsonEncode(object.toJson());
}
