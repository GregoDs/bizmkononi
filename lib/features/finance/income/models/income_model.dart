// To parse this JSON data, do
//
//     final incomeModel = incomeModelFromJson(jsonString);

import 'dart:convert';

IncomeModel incomeModelFromJson(String str) => IncomeModel.fromJson(json.decode(str));

String incomeModelToJson(IncomeModel data) => json.encode(data.toJson());

class IncomeModel {
    int? count;
    List<IncomeModelRow>? rows;

    IncomeModel({
        this.count,
        this.rows,
    });

    factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<IncomeModelRow>.from(json["rows"]!.map((x) => IncomeModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class IncomeModelRow {
    String? id;
    String? businessId;
    String? title;
    String? amount;
    String? description;
    DateTime? txDate;
    DateTime? createdAt;
    DateTime? updatedAt;

    IncomeModelRow({
        this.id,
        this.businessId,
        this.title,
        this.amount,
        this.description,
        this.txDate,
        this.createdAt,
        this.updatedAt,
    });

    factory IncomeModelRow.fromJson(Map<String, dynamic> json) => IncomeModelRow(
        id: json["id"],
        businessId: json["businessId"],
        title: json["title"],
        amount: json["amount"],
        description: json["description"],
        txDate: json["txDate"] == null ? null : DateTime.parse(json["txDate"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessId": businessId,
        "title": title,
        "amount": amount,
        "description": description,
        "txDate": txDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
