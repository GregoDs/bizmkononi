
import 'dart:convert';

BusinessModel businessModelFromJson(String str) => BusinessModel.fromJson(json.decode(str));

String businessModelToJson(BusinessModel data) => json.encode(data.toJson());

class BusinessModel {
    int? count;
    List<BusinessModelRows>? rows;

    BusinessModel({
        this.count,
        this.rows,
    });

    factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        count: json["count"],
        rows: json["rows"] == null ? [] : List<BusinessModelRows>.from(json["rows"]!.map((x) => BusinessModelRows.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
    };
}

class BusinessModelRows {
    String? id;
    String? ownerId;
    String? name;
    String? imageUrl;
    String? imageId;
    String? description;
    String? location;
    double? latitude;
    double? longitude;
    String? locationDetails;
    String? productType;
    String? businessEmail;
    String? businessPhone;
    DateTime? createdAt;
    DateTime? updatedAt;
    Owner? owner;

    BusinessModelRows({
        this.id,
        this.ownerId,
        this.name,
        this.imageUrl,
        this.imageId,
        this.description,
        this.location,
        this.latitude,
        this.longitude,
        this.locationDetails,
        this.productType,
        this.businessEmail,
        this.businessPhone,
        this.createdAt,
        this.updatedAt,
        this.owner,
    });

    factory BusinessModelRows.fromJson(Map<String, dynamic> json) => BusinessModelRows(
        id: json["id"],
        ownerId: json["ownerId"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        imageId: json["imageId"],
        description: json["description"],
        location: json["location"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        locationDetails: json["locationDetails"],
        productType: json["productType"],
        businessEmail: json["businessEmail"],
        businessPhone: json["businessPhone"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ownerId": ownerId,
        "name": name,
        "imageUrl": imageUrl,
        "imageId": imageId,
        "description": description,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "locationDetails": locationDetails,
        "productType": productType,
        "businessEmail": businessEmail,
        "businessPhone": businessPhone,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "owner": owner?.toJson(),
    };
}

class Owner {
    String? id;
    String? name;
    String? email;
    String? subscriptionType;
    dynamic freeTrialStartDate;
    bool? phoneVerified;
    String? phone;
    DateTime? createdAt;
    DateTime? updatedAt;

    Owner({
        this.id,
        this.name,
        this.email,
        this.subscriptionType,
        this.freeTrialStartDate,
        this.phoneVerified,
        this.phone,
        this.createdAt,
        this.updatedAt,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        subscriptionType: json["subscriptionType"],
        freeTrialStartDate: json["freeTrialStartDate"],
        phoneVerified: json["phoneVerified"],
        phone: json["phone"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "subscriptionType": subscriptionType,
        "freeTrialStartDate": freeTrialStartDate,
        "phoneVerified": phoneVerified,
        "phone": phone,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
