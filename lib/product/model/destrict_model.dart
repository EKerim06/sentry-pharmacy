// To parse this JSON data, do
//
//     final destrictModel = destrictModelFromJson(jsonString);

import 'dart:convert';

class DestrictModel {
  String status;
  String message;
  int systemTime;
  int rowCount;
  List<Datum> data;

  DestrictModel({
    required this.status,
    required this.message,
    required this.systemTime,
    required this.rowCount,
    required this.data,
  });

  factory DestrictModel.fromRawJson(String str) =>
      DestrictModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DestrictModel.fromJson(Map<String, dynamic> json) => DestrictModel(
        status: json["status"],
        message: json["message"],
        systemTime: json["systemTime"],
        rowCount: json["rowCount"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "systemTime": systemTime,
        "rowCount": rowCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String ilceAd;
  String ilceSlug;

  Datum({
    required this.ilceAd,
    required this.ilceSlug,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ilceAd: json["ilceAd"],
        ilceSlug: json["ilceSlug"],
      );

  Map<String, dynamic> toJson() => {
        "ilceAd": ilceAd,
        "ilceSlug": ilceSlug,
      };
}
