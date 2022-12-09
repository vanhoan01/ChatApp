import 'package:json_annotation/json_annotation.dart';

part "ChatModel.g.dart";

@JsonSerializable()
class ChatModel {
  late String userName;
  late String displayName;
  late String avatarImage;
  late bool isGroup;
  late String timestamp;
  late String currentMessage;
  late String status;
  late bool select = false;

  ChatModel({
    required this.userName,
    required this.displayName,
    required this.avatarImage,
    required this.isGroup,
    required this.timestamp,
    required this.currentMessage,
  });
  ChatModel.ChatModelContact(this.displayName, this.status);
  ChatModel.ChatModelGroup({
    required this.userName,
    required this.displayName,
    required this.status,
    this.select = false,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
