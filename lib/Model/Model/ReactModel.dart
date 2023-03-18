// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';

part 'ReactModel.g.dart';

@JsonSerializable()
class ReactModel {
  ReactModel({required this.userId, required this.react});
  final String userId;
  late String react;

  factory ReactModel.fromJson(Map<String, dynamic> json) =>
      _$ReactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReactModelToJson(this);
}
// flutter clean
// flutter pub get
// flutter pub run build_runner build --delete-conflicting-outputs