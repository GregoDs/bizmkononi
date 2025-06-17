// To parse this JSON data, do
//
//     final suppliesModel = suppliesModelFromJson(jsonString);

import 'dart:convert';

SuppliesModel suppliesModelFromJson(String str) =>
    SuppliesModel.fromJson(json.decode(str));

String suppliesModelToJson(SuppliesModel data) => json.encode(data.toJson());

class SuppliesModel {
  int? count;
  List<SuppliesModelRow>? rows;

  SuppliesModel({
    this.count,
    this.rows,
  });

  factory SuppliesModel.fromJson(Map<String, dynamic> json) => SuppliesModel(
        count: json["count"],
        rows: json["rows"] == null
            ? []
            : List<SuppliesModelRow>.from(
                json["rows"]!.map((x) => SuppliesModelRow.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class SuppliesModelRow {
  String? id;
  String? businessId;
  String? supplierId;
  String? totalAmount;
  String? amountCharged;
  String? amountPaid;
  DateTime? createdAt;
  DateTime? updatedAt;
  Supplier? supplier;
  List<SupplyItem>? supplyItems; // Added supplyItems field

  SuppliesModelRow({
    this.id,
    this.businessId,
    this.supplierId,
    this.totalAmount,
    this.amountCharged,
    this.amountPaid,
    this.createdAt,
    this.updatedAt,
    this.supplier,
    this.supplyItems, // Initialize supplyItems
  });

  factory SuppliesModelRow.fromJson(Map<String, dynamic> json) =>
      SuppliesModelRow(
        id: json["id"],
        businessId: json["businessId"],
        supplierId: json["supplierId"],
        totalAmount: json["totalAmount"],
        amountCharged: json["amountCharged"],
        amountPaid: json["amountPaid"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        supplier: json["supplier"] == null
            ? null
            : Supplier.fromJson(json["supplier"]),
        supplyItems: json["supplyItems"] == null
            ? []
            : List<SupplyItem>.from(
                json["supplyItems"].map((x) => SupplyItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "supplierId": supplierId,
        "totalAmount": totalAmount,
        "amountCharged": amountCharged,
        "amountPaid": amountPaid,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "supplier": supplier?.toJson(),
        "supplyItems": supplyItems == null
            ? []
            : List<dynamic>.from(supplyItems!.map((x) => x.toJson())),
      };
}

class Supplier {
  String? id;
  String? businessId;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? description;
  String? imageId;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Supplier({
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

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: json["id"],
        businessId: json["businessId"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        imageId: json["imageId"],
        imageUrl: json["imageUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
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

class SupplyProduct {
  String productId;
  String supplyPrice; // unit price
  String quantity;
  String productName;
  String totalAmount; // add this

  SupplyProduct({
    this.productId = '',
    this.supplyPrice = '',
    this.quantity = '',
    this.productName = '',
    this.totalAmount = '',
  });

  Map toJson() => {
        'productId': productId,
        'supplyPrice': supplyPrice,
        'quantity': quantity,
        'productName': productName,
        'totalAmount': totalAmount,
      };
}

class SupplyItem {
  String? id;
  String? supplyId;
  String? productId;
  String? productBp;
  String? supplyPrice;
  String? quantity;
  String? totalAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  Product? product;

  SupplyItem({
    this.id,
    this.supplyId,
    this.productId,
    this.productBp,
    this.supplyPrice,
    this.quantity,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory SupplyItem.fromJson(Map<String, dynamic> json) => SupplyItem(
        id: json["id"],
        supplyId: json["supplyId"],
        productId: json["productId"],
        productBp: json["productBp"],
        supplyPrice: json["supplyPrice"],
        quantity: json["quantity"],
        totalAmount: json["totalAmount"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supplyId": supplyId,
        "productId": productId,
        "productBp": productBp,
        "supplyPrice": supplyPrice,
        "quantity": quantity,
        "totalAmount": totalAmount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
      };
}

class Product {
  String? id;
  String? name;
  String? description;

  Product({
    this.id,
    this.name,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
