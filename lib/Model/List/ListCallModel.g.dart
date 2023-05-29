// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListCallModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCallModel _$ListCallModelFromJson(Map<String, dynamic> json) =>
    ListCallModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CallModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListCallModelToJson(ListCallModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
