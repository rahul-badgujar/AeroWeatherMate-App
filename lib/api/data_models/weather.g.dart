// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
    json['ts'],
    json['tp'],
    json['pr'],
    json['hu'],
    json['ws'],
    json['wd'],
    json['ic'],
  );
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'ts': instance.timeStamp,
      'tp': instance.temprature,
      'pr': instance.pressure,
      'hu': instance.humidity,
      'ws': instance.windSpeed,
      'wd': instance.windDirection,
      'ic': instance.weatherStatusCode,
    };
