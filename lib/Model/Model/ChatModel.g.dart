// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['_id'] as String?,
      userName: json['userName'] as String,
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String,
      isGroup: json['isGroup'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      currentMessage: json['currentMessage'] as String,
    )
      ..status = json['status'] as String
      ..select = json['select'] as bool;

ChatModel _$ForwardFromJson(Map<String, dynamic> json) => ChatModel.Forward(
      userName: json['userName'] as String,
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String,
      isGroup: json['isGroup'] as bool,
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      '_id': instance.id,
      'userName': instance.userName,
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'isGroup': instance.isGroup,
      'timestamp': instance.timestamp,
      'currentMessage': instance.currentMessage,
      'status': instance.status,
      'select': instance.select,
    };
