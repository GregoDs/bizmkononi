// To parse this JSON data, do
//
//     final customerChurnModel = customerChurnModelFromJson(jsonString);

import 'dart:convert';

CustomerChurnModel customerChurnModelFromJson(String str) => CustomerChurnModel.fromJson(json.decode(str));

String customerChurnModelToJson(CustomerChurnModel data) => json.encode(data.toJson());

class CustomerChurnModel {
    int? rate;

    CustomerChurnModel({
        this.rate,
    });

    factory CustomerChurnModel.fromJson(Map<String, dynamic> json) => CustomerChurnModel(
        rate: json["rate"],
    );

    Map<String, dynamic> toJson() => {
        "rate": rate,
    };
}
