// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListMemberModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListMemberModel _$ListMemberModelFromJson(Map<String, dynamic> json) =>
    ListMemberModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListMemberModelToJson(ListMemberModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
