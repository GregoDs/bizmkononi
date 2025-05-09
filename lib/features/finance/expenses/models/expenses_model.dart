// To parse this JSON data, do
//
//     final expensesModel = expensesModelFromJson(jsonString);

import 'dart:convert';

ExpensesModel expensesModelFromJson(String str) => ExpensesModel.fromJson(json.decode(str));

String expensesModelToJson(ExpensesModel data) => json.encode(data.toJson());

class ExpensesModel {
    int? count;
    List<ExpensesModelRow>? rows;

    ExpensesModel({
        this.count,
        this.rows,
    });

    factory ExpensesModel.fromJson(Map<String, dynamic> json) => ExpensesModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<ExpensesModelRow>.from(json["rows"]!.map((x) => ExpensesModelRow.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class ExpensesModelRow {
    String? id;
    String? businessId;
    String? title;
    String? amount;
    String? description;
    DateTime? txDate;
    DateTime? createdAt;
    DateTime? updatedAt;

    ExpensesModelRow({
        this.id,
        this.businessId,
        this.title,
        this.amount,
        this.description,
        this.txDate,
        this.createdAt,
        this.updatedAt,
    });

    factory ExpensesModelRow.fromJson(Map<String, dynamic> json) => ExpensesModelRow(
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
