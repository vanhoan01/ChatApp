// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part "SearchModel.g.dart";

@JsonSerializable()
class SearchModel {
  late String userName;
  late String displayName;
  late String avatarImage;
  late bool isGroup;
  late String? status;

  SearchModel({
    required this.userName,
    required this.displayName,
    required this.avatarImage,
    required this.isGroup,
    this.status,
  });
  // ignore: non_constant_identifier_names

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      _$SearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}
