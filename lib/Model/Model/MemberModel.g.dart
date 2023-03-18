// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MemberModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      userName: json['userName'] as String,
      memberShipStatus: json['memberShipStatus'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'memberShipStatus': instance.memberShipStatus,
      'joinDate': instance.joinDate.toIso8601String(),
    };
