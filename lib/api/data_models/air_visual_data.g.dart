// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_visual_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirVisualData _$currentAirVisualDataFromJson(Map<String, dynamic> json) {
  return AirVisualData(
    callStatus: json['status'],
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );
}
