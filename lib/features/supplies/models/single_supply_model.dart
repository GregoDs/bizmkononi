// To parse this JSON data, do
//
//     final singleSupplyModel = singleSupplyModelFromJson(jsonString);

import 'dart:convert';

SingleSupplyModel singleSupplyModelFromJson(String str) => SingleSupplyModel.fromJson(json.decode(str));

String singleSupplyModelToJson(SingleSupplyModel data) => json.encode(data.toJson());

class SingleSupplyModel {
    String? id;
    String? businessId;
    String? supplierId;
    String? totalAmount;
    String? amountCharged;
    String? amountPaid;
    DateTime? createdAt;
    DateTime? updatedAt;
    Supplier? supplier;
    List<SupplyItem>? supplyItems;

    SingleSupplyModel({
        this.id,
        this.businessId,
        this.supplierId,
        this.totalAmount,
        this.amountCharged,
        this.amountPaid,
        this.createdAt,
        this.updatedAt,
        this.supplier,
        this.supplyItems,
    });

    factory SingleSupplyModel.fromJson(Map<String, dynamic> json) => SingleSupplyModel(
        id: json["id"],
        businessId: json["businessId"],
        supplierId: json["supplierId"],
        totalAmount: json["totalAmount"],
        amountCharged: json["amountCharged"],
        amountPaid: json["amountPaid"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        supplier: json["supplier"] == null ? null : Supplier.fromJson(json["supplier"]),
        supplyItems: json["supplyItems"] == null ? [] : List<SupplyItem>.from(json["supplyItems"]!.map((x) => SupplyItem.fromJson(x))),
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
        "supplyItems": supplyItems == null ? [] : List<dynamic>.from(supplyItems!.map((x) => x.toJson())),
    };
}

class Supplier {
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

class SupplyItem {
    String? id;
    String? supplyId;
    String? productId;
    String? productBp;
    String? supplyPrice;
    int? quantity;
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
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
    String? businessId;
    String? categoryId;
    String? name;
    String? description;
    String? imageId;
    String? imageUrl;
    String? tags;
    int? size;
    String? unit;
    String? sellingPrice;
    String? buyingPrice;
    int? stock;
    String? productType;
    DateTime? createdAt;
    DateTime? updatedAt;

    Product({
        this.id,
        this.businessId,
        this.categoryId,
        this.name,
        this.description,
        this.imageId,
        this.imageUrl,
        this.tags,
        this.size,
        this.unit,
        this.sellingPrice,
        this.buyingPrice,
        this.stock,
        this.productType,
        this.createdAt,
        this.updatedAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        businessId: json["businessId"],
        categoryId: json["categoryId"],
        name: json["name"],
        description: json["description"],
        imageId: json["imageId"],
        imageUrl: json["imageUrl"],
        tags: json["tags"],
        size: json["size"],
        unit: json["unit"],
        sellingPrice: json["sellingPrice"],
        buyingPrice: json["buyingPrice"],
        stock: json["stock"],
        productType: json["productType"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "categoryId": categoryId,
        "name": name,
        "description": description,
        "imageId": imageId,
        "imageUrl": imageUrl,
        "tags": tags,
        "size": size,
        "unit": unit,
        "sellingPrice": sellingPrice,
        "buyingPrice": buyingPrice,
        "stock": stock,
        "productType": productType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
