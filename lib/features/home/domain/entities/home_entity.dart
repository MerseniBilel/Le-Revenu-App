import 'dart:convert';

HomeEntity homeEntityFromJson(String str) =>
    HomeEntity.fromJson(json.decode(str));

String homeEntityToJson(HomeEntity data) => json.encode(data.toJson());

class HomeEntity {
  HomeEntity();

  factory HomeEntity.fromJson(Map<String, dynamic> json) => HomeEntity();

  Map<String, dynamic> toJson() => {};
}
