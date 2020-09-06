// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forecast _$ForecastFromJson(Map<String, dynamic> json) {
  return Forecast(
    json['ts'],
    json['aqius'],
    json['tp'],
    json['pr'],
    json['hu'],
    json['ws'],
    json['wd'],
    json['ic'],
  );
}

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
      'ts': instance.timeStamp,
      'aqius': instance.aqiUS,
      'tp': instance.temprature,
      'pr': instance.pressure,
      'hu': instance.humidity,
      'ws': instance.windSpeed,
      'wd': instance.windDirection,
      'ic': instance.weatherStatusCode,
    };
