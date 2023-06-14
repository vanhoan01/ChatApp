// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListChatterModel.g.dart';

@JsonSerializable()
class ListChatterModel {
  final List<ChatterModel>? data;
  ListChatterModel({this.data});
  factory ListChatterModel.fromJson(Map<String, dynamic> json) =>
      _$ListChatterModelFromJson(json);
  factory ListChatterModel.fromJsonSearch(Map<String, dynamic> json) =>
      _$ListChatterModelFromJsonSearch(json);
  Map<String, dynamic> toJson() => _$ListChatterModelToJson(this);
}
//flutter pub run build_runner build