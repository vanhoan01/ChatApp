// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String?,
      partition: json['partition'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String?,
      biography: json['biography'] as String?,
      lastSeenAt: json['lastSeenAt'] == null
          ? null
          : DateTime.parse(json['lastSeenAt'] as String),
      phoneNumber: json['phoneNumber'] as String,
      conversations: (json['conversations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      precense: json['precense'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'partition': instance.partition,
      'username': instance.userName,
      'password': instance.password,
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'biography': instance.biography,
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'conversations': instance.conversations,
      'precense': instance.precense,
      'link': instance.link,
    };
