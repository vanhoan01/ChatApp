// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'CallModel.g.dart';

@JsonSerializable()
class CallModel {
  CallModel(
      {required this.displayName,
      required this.avatarImage,
      required this.timestamp,
      required this.type,
      required this.text,
      required this.isGroup,
      required this.precense});
  final String displayName;
  final DateTime timestamp;
  final String avatarImage;
  final bool isGroup;
  final String precense;
  final String type;
  final String text;

  factory CallModel.fromJson(Map<String, dynamic> json) =>
      _$CallModelFromJson(json);

  Map<String, dynamic> toJson() => _$CallModelToJson(this);
}
// flutter clean
// flutter pub get
// flutter pub run build_runner build --delete-conflicting-outputs