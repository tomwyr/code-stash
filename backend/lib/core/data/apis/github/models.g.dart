// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUsersData _$SearchUsersDataFromJson(Map<String, dynamic> json) =>
    SearchUsersData(
      items: (json['items'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchUsersDataToJson(SearchUsersData instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'html_url': instance.htmlUrl,
    };

UserRepo _$UserRepoFromJson(Map<String, dynamic> json) => UserRepo(
      language: json['language'] as String?,
    );

Map<String, dynamic> _$UserRepoToJson(UserRepo instance) => <String, dynamic>{
      'language': instance.language,
    };
