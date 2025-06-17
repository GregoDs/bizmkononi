// To parse this JSON data, do
//
//     final salesModel = salesModelFromJson(jsonString);

import 'dart:convert';

SalesModel salesModelFromJson(String str) => SalesModel.fromJson(json.decode(str));

String salesModelToJson(SalesModel data) => json.encode(data.toJson());

class SalesModel {
    int? count;
    List<SalesModelRow>? rows;

    SalesModel({
        this.count,
        this.rows,
    });

    factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<SalesModelRow>.from(json["rows"]!.map((x) => SalesModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class SalesModelRow {
    String? id;
    String? businessId;
    String? customerId;
    String? totalAmount;
    String? amountCharged;
    String? amountPaid;
    DateTime? createdAt;
    DateTime? updatedAt;
    Customer? customer;

    SalesModelRow({
        this.id,
        this.businessId,
        this.customerId,
        this.totalAmount,
        this.amountCharged,
        this.amountPaid,
        this.createdAt,
        this.updatedAt,
        this.customer,
    });

    factory SalesModelRow.fromJson(Map<String, dynamic> json) => SalesModelRow(
        id: json["id"],
        businessId: json["businessId"],
        customerId: json["customerId"],
        totalAmount: json["totalAmount"],
        amountCharged: json["amountCharged"],
        amountPaid: json["amountPaid"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "customerId": customerId,
        "totalAmount": totalAmount,
        "amountCharged": amountCharged,
        "amountPaid": amountPaid,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "customer": customer?.toJson(),
    };
}

class Customer {
    String? id;
    String? businessId;
    dynamic userId;
    String? name;
    String? email;
    String? phone;
    String? description;
    String? gender;
    int? yearOfBirth;
    String? imageId;
    String? imageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;

    Customer({
        this.id,
        this.businessId,
        this.userId,
        this.name,
        this.email,
        this.phone,
        this.description,
        this.gender,
        this.yearOfBirth,
        this.imageId,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        businessId: json["businessId"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        gender: json["gender"],
        yearOfBirth: json["yearOfBirth"],
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
        "gender": gender,
        "yearOfBirth": yearOfBirth,
        "imageId": imageId,
        "imageUrl": imageUrl,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}


class SaleProduct {
  String productId;
  String salePrice; // unit price
  String quantity;
  String productName;
  String totalAmount; // add this

  SaleProduct({
    this.productId = '',
    this.salePrice = '',
    this.quantity = '',
    this.productName = '',
    this.totalAmount = '',
  });

  Map toJson() => {
        'productId': productId,
        'salePrice': salePrice,
        'quantity': quantity,
        'productName': productName,
        'totalAmount': totalAmount,
      };
}