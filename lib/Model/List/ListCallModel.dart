// ignore_for_file: file_names

import 'package:chatapp/Model/Model/CallModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListCallModel.g.dart';

@JsonSerializable()
class ListCallModel {
  ListCallModel({this.data});
  final List<CallModel>? data;
  factory ListCallModel.fromJson(Map<String, dynamic> json) =>
      _$ListCallModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListCallModelToJson(this);
}
//flutter pub run build_runner build