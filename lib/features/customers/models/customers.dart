// To parse this JSON data, do
//
//     final customersModel = customersModelFromJson(jsonString);

import 'dart:convert';

CustomersModel customersModelFromJson(String str) => CustomersModel.fromJson(json.decode(str));

String customersModelToJson(CustomersModel data) => json.encode(data.toJson());

class CustomersModel {
    int? count;
    List<CustomersModelRow>? rows;

    CustomersModel({
        this.count,
        this.rows,
    });

    factory CustomersModel.fromJson(Map<String, dynamic> json) => CustomersModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<CustomersModelRow>.from(json["rows"]!.map((x) => CustomersModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class CustomersModelRow {
    String? id;
    String? businessId;
    dynamic userId;
    String? name;
    String? email;
    String? phone;
    String? description;
    String? gender;
    int? yearOfBirth;
    DateTime? createdAt;
    DateTime? updatedAt;

    CustomersModelRow({
        this.id,
        this.businessId,
        this.userId,
        this.name,
        this.email,
        this.phone,
        this.description,
        this.gender,
        this.yearOfBirth,
        this.createdAt,
        this.updatedAt,
    });

    factory CustomersModelRow.fromJson(Map<String, dynamic> json) => CustomersModelRow(
        id: json["id"],
        businessId: json["businessId"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        gender: json["gender"],
        yearOfBirth: json["yearOfBirth"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "userId": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "description": description,
        "gender": gender,
        "yearOfBirth": yearOfBirth,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
