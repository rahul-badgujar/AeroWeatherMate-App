import 'package:json_annotation/json_annotation.dart';

part 'forecast.g.dart';

@JsonSerializable()
class Forecast {
  @JsonKey(name: 'ts')
  final timeStamp;

  @JsonKey(name: 'aqius')
  final aqiUS;

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

  Forecast(
      this.timeStamp,
      this.aqiUS,
      this.temprature,
      this.pressure,
      this.humidity,
      this.windSpeed,
      this.windDirection,
      this.weatherStatusCode);

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);
}
