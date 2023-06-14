// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OthersStatusModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OthersStatusModel _$OthersStatusModelFromJson(Map<String, dynamic> json) =>
    OthersStatusModel(
      userName: json['userName'] == null
          ? json['_id'] as String
          : json['userName'] as String,
      displayName: json['displayName'] as String,
      avatarImage:
          json['avatarImage'] == null ? "" : json['avatarImage'] as String,
      lastSeenAt: json['lastSeenAt'] == null
          ? DateTime.parse('2023-01-01')
          : DateTime.parse(json['lastSeenAt'] as String),
      isGroup: json['isGroup'] == null ? false : json['isGroup'] as bool,
      precense: json['precense'] == null
          ? "Không hoạt động"
          : json['precense'] as String,
    );

Map<String, dynamic> _$OthersStatusModelToJson(OthersStatusModel instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'lastSeenAt': instance.lastSeenAt,
      'isGroup': instance.isGroup,
      'precense': instance.precense,
    };
