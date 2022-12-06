import 'package:json_annotation/json_annotation.dart';

part "ChatMessagesModel.g.dart";

@JsonSerializable()
class ChatMessagesModel {
  ChatMessagesModel({
    required this.author,
    this.partition,
    this.avatarAuthor,
    this.isGroup,
    required this.text,
    required this.image,
    required this.timestamp,
  });

  final String author;
  final String? partition;
  final String? avatarAuthor;
  final bool? isGroup;
  final String text;
  final String image;
  final DateTime timestamp;

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessagesModelToJson(this);
}
//flutter pub run build_runner build
