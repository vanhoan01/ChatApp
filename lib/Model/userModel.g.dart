// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      partition: json['partition'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String?,
      lastSeenAt: json['lastSeenAt'] == null
          ? null
          : DateTime.parse(json['lastSeenAt'] as String),
      phoneNumber: json['phoneNumber'] as String,
      conversations: (json['conversations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      precense: json['precense'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'partition': instance.partition,
      'username': instance.username,
      'password': instance.password,
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'conversations': instance.conversations,
      'precense': instance.precense,
    };
