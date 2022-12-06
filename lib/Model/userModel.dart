import 'package:json_annotation/json_annotation.dart';

part "userModel.g.dart";

@JsonSerializable()
class UserModel {
  UserModel(
      {required this.partition,
      required this.username,
      required this.password,
      required this.displayName,
      this.avatarImage,
      this.lastSeenAt,
      required this.phoneNumber,
      this.conversations,
      this.precense});
  final String partition;
  final String username;
  final String password;
  final String displayName;
  final String? avatarImage;
  final DateTime? lastSeenAt;
  final String phoneNumber;
  final List<String>? conversations;
  final String? precense;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
// flutter clean
// flutter pub get
// flutter pub run build_runner build --delete-conflicting-outputs