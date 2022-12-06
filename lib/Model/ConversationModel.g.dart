// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConversationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: json['_id'] as String,
      displayName: json['displayName'] as String,
      unreadCount: json['unreadCount'] as int?,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'displayName': instance.displayName,
      'unreadCount': instance.unreadCount,
      'members': instance.members,
    };
