// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Current _$CurrentFromJson(Map<String, dynamic> json) {
  return Current(
    json['weather'] == null
        ? null
        : Weather.fromJson(json['weather'] as Map<String, dynamic>),
    json['pollution'] == null
        ? null
        : Pollution.fromJson(json['pollution'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'weather': instance.weather,
      'pollution': instance.pollution,
    };
