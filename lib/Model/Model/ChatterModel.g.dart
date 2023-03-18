// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatterModel _$ChatterModelFromJson(Map<String, dynamic> json) => ChatterModel(
      partition: json['partition'] as String?,
      userName: json['userName'] as String,
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String?,
      lastSeenAt: json['lastSeenAt'] == null
          ? null
          : DateTime.parse(json['lastSeenAt'] as String),
      precense: json['precense'] as String?,
    );

Map<String, dynamic> _$ChatterModelToJson(ChatterModel instance) =>
    <String, dynamic>{
      'partition': instance.partition,
      'userName': instance.userName,
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
      'precense': instance.precense,
    };
