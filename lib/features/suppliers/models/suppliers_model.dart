// To parse this JSON data, do
//
//     final suppliersModel = suppliersModelFromJson(jsonString);

import 'dart:convert';

SuppliersModel suppliersModelFromJson(String str) => SuppliersModel.fromJson(json.decode(str));

String suppliersModelToJson(SuppliersModel data) => json.encode(data.toJson());

class SuppliersModel {
    int? count;
    List<SuppliersModelRow>? rows;

    SuppliersModel({
        this.count,
        this.rows,
    });

    factory SuppliersModel.fromJson(Map<String, dynamic> json) => SuppliersModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<SuppliersModelRow>.from(json["rows"]!.map((x) => SuppliersModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class SuppliersModelRow {
    String? id;
    String? businessId;
    dynamic userId;
    String? name;
    String? email;
    String? phone;
    String? description;
    String? imageId;
    String? imageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;

    SuppliersModelRow({
        this.id,
        this.businessId,
        this.userId,
        this.name,
        this.email,
        this.phone,
        this.description,
        this.imageId,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
    });

    factory SuppliersModelRow.fromJson(Map<String, dynamic> json) => SuppliersModelRow(
        id: json["id"],
        businessId: json["businessId"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        imageId: json["imageId"],
        imageUrl: json["imageUrl"],
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
        "imageId": imageId,
        "imageUrl": imageUrl,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
