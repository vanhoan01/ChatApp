part of 'ReactModel.dart';

ReactModel _$ReactModelFromJson(Map<String, dynamic> json) => ReactModel(
      userId: json['userId'] as String,
      react: json['react'] as String,
    );

Map<String, dynamic> _$ReactModelToJson(ReactModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'react': instance.react,
    };
