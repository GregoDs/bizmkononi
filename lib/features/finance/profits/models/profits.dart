import 'dart:convert';

List<ProfitsInsights> profitsInsightsFromJson(String str) => List<ProfitsInsights>.from(json.decode(str).map((x) => ProfitsInsights.fromJson(x)));

String profitsInsightsToJson(List<ProfitsInsights> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfitsInsights {
    ProfitsInsights({
        required this.group,
        required this.total,
    }); 

    String group;
    int total;

    factory ProfitsInsights.fromJson(Map<String, dynamic> json) => ProfitsInsights(
        group: json["group"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "group": group,
        "total": total,
    };
}
