// ignore_for_file: file_names

import 'package:chatapp/Model/Model/MemberModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListMemberModel.g.dart';

@JsonSerializable()
class ListMemberModel {
  final List<MemberModel>? data;
  ListMemberModel({this.data});
  factory ListMemberModel.fromJson(Map<String, dynamic> json) =>
      _$ListMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListMemberModelToJson(this);
}
//flutter pub run build_runner build