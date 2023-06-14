// ignore_for_file: file_names

import 'package:chatapp/Model/Model/SearchModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListSearchModel.g.dart';

@JsonSerializable()
class ListSearchModel {
  final List<SearchModel>? data;
  ListSearchModel({this.data});
  factory ListSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ListSearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListSearchModelToJson(this);
}
//flutter pub run build_runner build