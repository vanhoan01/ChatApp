// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListChatMessagesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChatMessagesModel _$ListChatMessagesModelFromJson(
        Map<String, dynamic> json) =>
    ListChatMessagesModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatMessagesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListChatMessagesModelToJson(
        ListChatMessagesModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
