// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMessagesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessagesModel _$ChatMessagesModelFromJson(Map<String, dynamic> json) =>
    ChatMessagesModel(
      id: json['_id'] as String,
      author: json['author'] as String,
      partition: json['partition'] as String?,
      isGroup: json['isGroup'] as bool?,
      type: json['type'] as String,
      text: json['text'] as String,
      size: json['size'] as int?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reacts: (json['reacts'] as List<dynamic>?)
          ?.map((e) => ReactModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reply: json['reply'] as String?,
    );

Map<String, dynamic> _$ChatMessagesModelToJson(ChatMessagesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'author': instance.author,
      'partition': instance.partition,
      'isGroup': instance.isGroup,
      'type': instance.type,
      'text': instance.text,
      'size': instance.size,
      'timestamp': instance.timestamp.toIso8601String(),
      'reacts': instance.reacts,
      'reply': instance.reply,
    };
