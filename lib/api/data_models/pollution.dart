import 'package:json_annotation/json_annotation.dart';

part 'pollution.g.dart';

@JsonSerializable()
class Pollution {
  @JsonKey(name: 'ts')
  final timeStamp;

  @JsonKey(name: 'aqius')
  final aqiUS;

  @JsonKey(name: 'mainus')
  final mainPollutantUS;

  @JsonKey(name: 'aqicn')
  final aqiCN;

  @JsonKey(name: 'maincn')
  final mainPollutantCN;

  Pollution(this.timeStamp, this.aqiUS, this.mainPollutantUS, this.aqiCN,
      this.mainPollutantCN);

  factory Pollution.fromJson(Map<String, dynamic> json) =>
      _$PollutionFromJson(json);
}
