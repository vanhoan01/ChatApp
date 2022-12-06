import 'package:chatapp/Model/ListMemberModel.dart';
import 'package:chatapp/Model/MemberModel.dart';
import 'package:json_annotation/json_annotation.dart';

part "ConversationModel.g.dart";

@JsonSerializable()
class ConversationModel {
  ConversationModel(
      {required this.id,
      required this.displayName,
      this.unreadCount,
      this.members});
  final String id;
  final String displayName;
  final int? unreadCount;
  final List<MemberModel>? members;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
// flutter clean
// flutter pub get
// flutter pub run build_runner build --delete-conflicting-outputs