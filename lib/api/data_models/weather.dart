import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  @JsonKey(name: 'ts')
  final timeStamp;

  @JsonKey(name: 'tp')
  final temprature;

  @JsonKey(name: 'pr')
  final pressure;

  @JsonKey(name: 'hu')
  final humidity;

  @JsonKey(name: 'ws')
  final windSpeed;

  @JsonKey(name: 'wd')
  final windDirection;

  @JsonKey(name: 'ic')
  final weatherStatusCode;

  Weather(this.timeStamp, this.temprature, this.pressure, this.humidity,
      this.windSpeed, this.windDirection, this.weatherStatusCode);

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
