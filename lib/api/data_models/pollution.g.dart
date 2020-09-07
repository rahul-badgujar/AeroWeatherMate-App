// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pollution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pollution _$PollutionFromJson(Map<String, dynamic> json) {
  return Pollution(
    json['ts'],
    json['aqius'],
    json['mainus'],
    json['aqicn'],
    json['maincn'],
  );
}

Map<String, dynamic> _$PollutionToJson(Pollution instance) => <String, dynamic>{
      'ts': instance.timeStamp,
      'aqius': instance.aqiUS,
      'mainus': instance.mainPollutantUS,
    };
