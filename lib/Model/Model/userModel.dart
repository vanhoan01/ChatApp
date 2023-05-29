// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable()
class UserModel {
  UserModel(
      {this.id,
      required this.partition,
      required this.userName,
      required this.password,
      required this.displayName,
      this.avatarImage,
      this.biography,
      this.lastSeenAt,
      required this.phoneNumber,
      this.conversations,
      this.precense,
      this.link,
      this.saved});
  final String? id;
  final String partition;
  final String userName;
  final String password;
  final String displayName;
  final String? avatarImage;
  final String? biography;
  final DateTime? lastSeenAt;
  final String phoneNumber;
  final List<String>? conversations;
  final String? precense;
  final String? link;
  final List<String>? saved;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
// flutter clean
// flutter pub get
// flutter pub run build_runner build --delete-conflicting-outputs