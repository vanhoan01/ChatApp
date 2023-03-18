// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ReactModel.dart';
import 'package:json_annotation/json_annotation.dart';

part "ChatMessagesModel.g.dart";

@JsonSerializable()
class ChatMessagesModel {
  ChatMessagesModel({
    this.id,
    required this.author,
    this.partition,
    this.avatarAuthor,
    this.isGroup,
    required this.type,
    required this.text,
    required this.timestamp,
    this.reacts,
    this.reply,
  });

  final String? id;
  final String author;
  final String? partition;
  final String? avatarAuthor;
  final bool? isGroup;
  final String type;
  final String text;
  final DateTime timestamp;
  final List<ReactModel>? reacts;
  final String? reply;

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessagesModelToJson(this);
}
//flutter pub run build_runner build
