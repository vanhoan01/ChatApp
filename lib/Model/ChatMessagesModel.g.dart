// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMessagesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessagesModel _$ChatMessagesModelFromJson(Map<String, dynamic> json) =>
    ChatMessagesModel(
      author: json['author'] as String,
      partition: json['partition'] as String?,
      isGroup: json['isGroup'] as bool?,
      text: json['text'] as String,
      image: json['image'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ChatMessagesModelToJson(ChatMessagesModel instance) =>
    <String, dynamic>{
      'author': instance.author,
      'partition': instance.partition,
      'isGroup': instance.isGroup,
      'text': instance.text,
      'image': instance.image,
      'timestamp': instance.timestamp.toIso8601String(),
    };
