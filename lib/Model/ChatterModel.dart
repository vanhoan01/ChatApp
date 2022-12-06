import 'package:json_annotation/json_annotation.dart';

part "ChatterModel.g.dart";

@JsonSerializable()
class ChatterModel {
  ChatterModel(
      {required this.partition,
      required this.userName,
      required this.displayName,
      this.avatarImage,
      this.lastSeenAt,
      this.precense});
  final String partition;
  final String userName;
  final String displayName;
  final String? avatarImage;
  final DateTime? lastSeenAt;
  final String? precense;

  factory ChatterModel.fromJson(Map<String, dynamic> json) =>
      _$ChatterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatterModelToJson(this);
}
// flutter clean
// flutter pub get
// flutter pub run build_runner build --delete-conflicting-outputs