// To parse this JSON data, do
//
//     final salariesModel = salariesModelFromJson(jsonString);

import 'dart:convert';

SalariesModel salariesModelFromJson(String str) => SalariesModel.fromJson(json.decode(str));

String salariesModelToJson(SalariesModel data) => json.encode(data.toJson());

class SalariesModel {
    int? count;
    List<SalariesModelRow>? rows;

    SalariesModel({
        this.count,
        this.rows,
    });

    factory SalariesModel.fromJson(Map<String, dynamic> json) => SalariesModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<SalariesModelRow>.from(json["rows"]!.map((x) => SalariesModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class SalariesModelRow {
    String? id;
    String? businessId;
    String? employeeId;
    String? amount;
    String? description;
    DateTime? txDate;
    DateTime? createdAt;
    DateTime? updatedAt;
    Employee? employee;

    SalariesModelRow({
        this.id,
        this.businessId,
        this.employeeId,
        this.amount,
        this.description,
        this.txDate,
        this.createdAt,
        this.updatedAt,
        this.employee,
    });

    factory SalariesModelRow.fromJson(Map<String, dynamic> json) => SalariesModelRow(
        id: json["id"],
        businessId: json["businessId"],
        employeeId: json["employeeId"],
        amount: json["amount"],
        description: json["description"],
        txDate: json["txDate"] == null ? null : DateTime.parse(json["txDate"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "employeeId": employeeId,
        "amount": amount,
        "description": description,
        "txDate": txDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "employee": employee?.toJson(),
    };
}

class Employee {
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

    Employee({
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

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
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
