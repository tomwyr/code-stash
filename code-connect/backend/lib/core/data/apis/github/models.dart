import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class SearchUsersData {
  SearchUsersData({required this.items});

  final List<User> items;

  factory SearchUsersData.fromJson(Map<String, dynamic> json) => _$SearchUsersDataFromJson(json);
  Map<String, dynamic> toJson() => _$SearchUsersDataToJson(this);
}

@JsonSerializable()
class User {
  User({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  final String login;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  @JsonKey(name: 'html_url')
  final String htmlUrl;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserRepo {
  UserRepo({required this.language});

  final String? language;

  factory UserRepo.fromJson(Map<String, dynamic> json) => _$UserRepoFromJson(json);
  Map<String, dynamic> toJson() => _$UserRepoToJson(this);
}
