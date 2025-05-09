// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(String str) => ProductsModel.fromJson(json.decode(str));

String productsModelToJson(ProductsModel data) => json.encode(data.toJson());

class ProductsModel {
    int? count;
    List<ProductsModelRow>? rows;

    ProductsModel({
        this.count,
        this.rows,
    });

    factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<ProductsModelRow>.from(json["rows"]!.map((x) => ProductsModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class ProductsModelRow {
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
    Category? category;

    ProductsModelRow({
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
        this.category,
    });

    factory ProductsModelRow.fromJson(Map<String, dynamic> json) => ProductsModelRow(
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
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
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
        "category": category?.toJson(),
    };
}

class Category {
    String? id;
    String? businessId;
    dynamic categoryId;
    String? name;
    String? description;
    String? imageId;
    String? imageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;

    Category({
        this.id,
        this.businessId,
        this.categoryId,
        this.name,
        this.description,
        this.imageId,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        businessId: json["businessId"],
        categoryId: json["categoryId"],
        name: json["name"],
        description: json["description"],
        imageId: json["imageId"],
        imageUrl: json["imageUrl"],
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
