// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListConversationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListConversationModel _$ListConversationModelFromJson(
        Map<String, dynamic> json) =>
    ListConversationModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListConversationModelToJson(
        ListConversationModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
