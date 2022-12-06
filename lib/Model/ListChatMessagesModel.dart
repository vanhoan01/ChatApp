import 'package:chatapp/Model/ChatMessagesModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListChatMessagesModel.g.dart';

@JsonSerializable()
class ListChatMessagesModel {
  final List<ChatMessagesModel>? data;
  ListChatMessagesModel({this.data});
  factory ListChatMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$ListChatMessagesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListChatMessagesModelToJson(this);
}
//flutter pub run build_runner build