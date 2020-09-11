// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['name'],
    json['city'],
    json['state'],
    json['country'],
    (json['forecast'] as List)
        ?.map((e) =>
            e == null ? null : Forecast.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['current'] == null
        ? null
        : Current.fromJson(json['current'] as Map<String, dynamic>),
    json['history'] == null
        ? null
        : History.fromJson(json['history'] as Map<String, dynamic>),
  );
}
