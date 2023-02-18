// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListOthersStatus.g.dart';

@JsonSerializable()
class ListOthersStatus {
  final List<OthersStatusModel>? data;
  ListOthersStatus({this.data});
  factory ListOthersStatus.fromJson(Map<String, dynamic> json) =>
      _$ListOthersStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ListOthersStatusToJson(this);
}
//flutter pub run build_runner build