// To parse this JSON data, do
//
//     final singleSalesModel = singleSalesModelFromJson(jsonString);

import 'dart:convert';

SingleSalesModel singleSalesModelFromJson(String str) => SingleSalesModel.fromJson(json.decode(str));

String singleSalesModelToJson(SingleSalesModel data) => json.encode(data.toJson());

class SingleSalesModel {
    String? id;
    String? businessId;
    String? customerId;
    String? totalAmount;
    String? amountCharged;
    String? amountPaid;
    DateTime? createdAt;
    DateTime? updatedAt;
    Customer? customer;
    List<SaleItem>? saleItems;

    SingleSalesModel({
        this.id,
        this.businessId,
        this.customerId,
        this.totalAmount,
        this.amountCharged,
        this.amountPaid,
        this.createdAt,
        this.updatedAt,
        this.customer,
        this.saleItems,
    });

    factory SingleSalesModel.fromJson(Map<String, dynamic> json) => SingleSalesModel(
        id: json["id"],
        businessId: json["businessId"],
        customerId: json["customerId"],
        totalAmount: json["totalAmount"],
        amountCharged: json["amountCharged"],
        amountPaid: json["amountPaid"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        saleItems: json["saleItems"] == null ? [] : List<SaleItem>.from(json["saleItems"]!.map((x) => SaleItem.fromJson(x))),
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
        "saleItems": saleItems == null ? [] : List<dynamic>.from(saleItems!.map((x) => x.toJson())),
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

class SaleItem {
    String? id;
    String? saleId;
    String? productId;
    String? productSp;
    String? salePrice;
    int? quantity;
    String? totalAmount;
    DateTime? createdAt;
    DateTime? updatedAt;
    Product? product;

    SaleItem({
        this.id,
        this.saleId,
        this.productId,
        this.productSp,
        this.salePrice,
        this.quantity,
        this.totalAmount,
        this.createdAt,
        this.updatedAt,
        this.product,
    });

    factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
        id: json["id"],
        saleId: json["saleId"],
        productId: json["productId"],
        productSp: json["productSp"],
        salePrice: json["salePrice"],
        quantity: json["quantity"],
        totalAmount: json["totalAmount"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "saleId": saleId,
        "productId": productId,
        "productSp": productSp,
        "salePrice": salePrice,
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
