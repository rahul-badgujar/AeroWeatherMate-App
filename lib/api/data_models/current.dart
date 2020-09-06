import 'package:json_annotation/json_annotation.dart';
import 'package:air_quality_app/api/data_models/weather.dart';
import 'package:air_quality_app/api/data_models/pollution.dart';

part 'current.g.dart';

@JsonSerializable()
class Current {
  @JsonKey(name: 'weather')
  final Weather weather;

  @JsonKey(name: 'pollution')
  final Pollution pollution;

  Current(this.weather, this.pollution);

  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);
}
