import 'package:json_annotation/json_annotation.dart';
import 'package:air_quality_app/api/data_models/current.dart';
import 'package:air_quality_app/api/data_models/history.dart';
import 'package:air_quality_app/api/data_models/forecast.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: 'name')
  final name;

  @JsonKey(name: 'city')
  final city;

  @JsonKey(name: 'state')
  final state;

  @JsonKey(name: 'country')
  final country;

  @JsonKey(name: 'forecast')
  final List<Forecast> forecasts;

  @JsonKey(name: 'current')
  final Current current;

  @JsonKey(name: 'history')
  final History history;

  Data(this.name, this.city, this.state, this.country, this.forecasts,
      this.current, this.history);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
