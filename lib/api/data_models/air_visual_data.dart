import 'package:json_annotation/json_annotation.dart';
import 'package:air_quality_app/api/data_models/data.dart';

part 'air_visual_data.g.dart';

@JsonSerializable()
class AirVisualData {
  @JsonKey(name: 'status')
  final callStatus;

  @JsonKey(name: 'data')
  final Data data;

  AirVisualData({this.callStatus, this.data});

  factory AirVisualData.fromJson(Map<String, dynamic> json) =>
      _$currentAirVisualDataFromJson(json);
}
