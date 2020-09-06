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

  Pollution(this.timeStamp, this.aqiUS, this.mainPollutantUS);

  factory Pollution.fromJson(Map<String, dynamic> json) =>
      _$PollutionFromJson(json);
}
