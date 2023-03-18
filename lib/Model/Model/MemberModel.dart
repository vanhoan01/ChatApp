// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part "MemberModel.g.dart";

@JsonSerializable()
class MemberModel {
  late String userName;
  late String memberShipStatus;
  late DateTime joinDate;

  MemberModel(
      {required this.userName,
      required this.memberShipStatus,
      required this.joinDate});
  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
