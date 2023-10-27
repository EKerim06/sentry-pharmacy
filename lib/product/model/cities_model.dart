// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

class CityModel {
    String status;
    String message;
    int systemTime;
    int rowCount;
    List<Datum> data;

    CityModel({
        required this.status,
        required this.message,
        required this.systemTime,
        required this.rowCount,
        required this.data,
    });

    factory CityModel.fromRawJson(String str) => CityModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
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
    String sehirAd;
    String sehirSlug;

    Datum({
        required this.sehirAd,
        required this.sehirSlug,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sehirAd: json["SehirAd"],
        sehirSlug: json["SehirSlug"],
    );

    Map<String, dynamic> toJson() => {
        "SehirAd": sehirAd,
        "SehirSlug": sehirSlug,
    };
}
