import 'package:json_annotation/json_annotation.dart';
import 'package:air_quality_app/api/data_models/weather.dart';
import 'package:air_quality_app/api/data_models/pollution.dart';

part 'history.g.dart';

@JsonSerializable()
class History {
  @JsonKey(name: 'weather')
  final List<Weather> weathers;

  @JsonKey(name: 'pollution')
  final List<Pollution> pollutions;

  History(this.weathers, this.pollutions);

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}
