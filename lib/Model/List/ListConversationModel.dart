// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ConversationModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListConversationModel.g.dart';

@JsonSerializable()
class ListConversationModel {
  ListConversationModel({this.data});
  final List<ConversationModel>? data;
  factory ListConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ListConversationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListConversationModelToJson(this);
}
//flutter pub run build_runner build