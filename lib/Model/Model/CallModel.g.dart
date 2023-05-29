// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CallModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallModel _$CallModelFromJson(Map<String, dynamic> json) => CallModel(
      displayName: json['displayName'] as String,
      avatarImage:
          json['avatarImage'] == null ? "" : json['avatarImage'] as String,
      timestamp: json['timestamp'] == null
          ? DateTime.parse('2023-01-01')
          : DateTime.parse(json['timestamp'] as String),
      isGroup: json['isGroup'] == null ? false : json['isGroup'] as bool,
      precense: json['precense'] == null
          ? "Không hoạt động"
          : json['precense'] as String,
      type: json['type'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$CallModelToJson(CallModel instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'timestamp': instance.timestamp,
      'isGroup': instance.isGroup,
      'precense': instance.precense,
      'type': instance.type,
      'text': instance.text,
    };
