// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListOthersStatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOthersStatus _$ListOthersStatusFromJson(Map<String, dynamic> json) =>
    ListOthersStatus(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OthersStatusModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListOthersStatusToJson(ListOthersStatus instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
