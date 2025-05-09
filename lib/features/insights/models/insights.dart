import 'dart:convert';

List<Insights> insightsFromJson(String str) => List<Insights>.from(json.decode(str).map((x) => Insights.fromJson(x)));

String insightsToJson(List<Insights> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Insights {
    Insights({
        required this.total,
        required this.group,
    });

    String total;
    DateTime group;

    factory Insights.fromJson(Map<String, dynamic> json) => Insights(
        total: json["total"],
        group: DateTime.parse(json["group"]),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "group": group.toIso8601String(),
    };
}
