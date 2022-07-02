import 'package:json_annotation/json_annotation.dart';
part 'user_settings.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class UserSettings {
  bool isShowNotice;
  bool isSetNotDisturb;
  String? notDisturbStartHour;
  String? notDisturbStartMine;
  String? notDisturbStopHour;
  String? notDisturbStopMine;
  String? textScale;
  UserSettings(
      {required this.isSetNotDisturb,
      required this.isShowNotice,
      this.notDisturbStartHour,
      this.notDisturbStartMine,
      this.notDisturbStopHour,
      this.notDisturbStopMine,
      required this.textScale});

  factory UserSettings.fromJson(Object? json) =>
      _$UserSettingsFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  List<Object?> get props => [
        isShowNotice,
        isSetNotDisturb,
        notDisturbStartHour,
        notDisturbStopMine,
        notDisturbStopHour,
        notDisturbStopMine,
        textScale
      ];
}
