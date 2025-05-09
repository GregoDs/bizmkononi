// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    int? count;
    List<CategoryModelRow>? rows;

    CategoryModel({
        this.count,
        this.rows,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<CategoryModelRow>.from(json["rows"]!.map((x) => CategoryModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class CategoryModelRow {
    String? id;
    String? businessId;
    dynamic categoryId;
    String? name;
    String? description;
    String? imageId;
    String? imageUrl;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic category;

    CategoryModelRow({
        this.id,
        this.businessId,
        this.categoryId,
        this.name,
        this.description,
        this.imageId,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.category,
    });

    factory CategoryModelRow.fromJson(Map<String, dynamic> json) => CategoryModelRow(
        id: json["id"],
        businessId: json["businessId"],
        categoryId: json["categoryId"],
        name: json["name"],
        description: json["description"],
        imageId: json["imageId"],
        imageUrl: json["imageUrl"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        category: json["category"],
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
        "category": category,
    };
}
