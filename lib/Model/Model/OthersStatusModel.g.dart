// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OthersStatusModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OthersStatusModel _$OthersStatusModelFromJson(Map<String, dynamic> json) =>
    OthersStatusModel(
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String,
      lastSeenAt: json['lastSeenAt'] == null
          ? DateTime.parse('2023-01-01')
          : DateTime.parse(json['lastSeenAt'] as String),
      isGroup: json['isGroup'] as bool,
    );

Map<String, dynamic> _$OthersStatusModelToJson(OthersStatusModel instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'lastSeenAt': instance.lastSeenAt,
      'isGroup': instance.isGroup,
    };