// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_visual_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirVisualData _$AirVisualDataFromJson(Map<String, dynamic> json) {
  return AirVisualData(
    callStatus: json['status'],
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AirVisualDataToJson(AirVisualData instance) =>
    <String, dynamic>{
      'status': instance.callStatus,
      'data': instance.data,
    };
