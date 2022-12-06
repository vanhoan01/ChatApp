// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListChatModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChatModel _$ListChatModelFromJson(Map<String, dynamic> json) =>
    ListChatModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListChatModelToJson(ListChatModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
