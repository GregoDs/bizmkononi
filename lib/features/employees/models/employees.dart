// To parse this JSON data, do
//
//     final employeesModel = employeesModelFromJson(jsonString);

import 'dart:convert';

EmployeesModel employeesModelFromJson(String str) => EmployeesModel.fromJson(json.decode(str));

String employeesModelToJson(EmployeesModel data) => json.encode(data.toJson());

class EmployeesModel {
    int? count;
    List<EmployeesModelRow>? rows;

    EmployeesModel({
        this.count,
        this.rows,
    });

    factory EmployeesModel.fromJson(Map<String, dynamic> json) => EmployeesModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<EmployeesModelRow>.from(json["rows"]!.map((x) => EmployeesModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class EmployeesModelRow {
    String? id;
    String? businessId;
    String? name;
    String? email;
    String? phone;
    String? imageId;
    String? imageUrl;
    int? idNumber;
    String? position;
    DateTime? createdAt;
    DateTime? updatedAt;

    EmployeesModelRow({
        this.id,
        this.businessId,
        this.name,
        this.email,
        this.phone,
        this.imageId,
        this.imageUrl,
        this.idNumber,
        this.position,
        this.createdAt,
        this.updatedAt,
    });

    factory EmployeesModelRow.fromJson(Map<String, dynamic> json) => EmployeesModelRow(
        id: json["id"],
        businessId: json["businessId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        imageId: json["imageId"],
        imageUrl: json["imageUrl"],
        idNumber: json["idNumber"],
        position: json["position"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "name": name,
        "email": email,
        "phone": phone,
        "imageId": imageId,
        "imageUrl": imageUrl,
        "idNumber": idNumber,
        "position": position,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
