// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListChatModel.g.dart';

@JsonSerializable()
class ListChatModel {
  final List<ChatModel>? data;
  ListChatModel({this.data});
  factory ListChatModel.fromJson(Map<String, dynamic> json) =>
      _$ListChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListChatModelToJson(this);
}
//flutter pub run build_runner build