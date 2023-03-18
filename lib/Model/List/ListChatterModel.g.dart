// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListChatterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChatterModel _$ListChatterModelFromJson(Map<String, dynamic> json) =>
    ListChatterModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListChatterModelToJson(ListChatterModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
