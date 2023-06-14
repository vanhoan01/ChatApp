// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SearchModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => SearchModel(
      userName: json['userName'] as String,
      displayName: json['displayName'] as String,
      avatarImage: json['avatarImage'] as String,
      isGroup: json['isGroup'] as bool,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'displayName': instance.displayName,
      'avatarImage': instance.avatarImage,
      'isGroup': instance.isGroup,
      'status': instance.status,
    };
