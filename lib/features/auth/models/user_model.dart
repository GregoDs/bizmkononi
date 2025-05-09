class UserModel {
  User? user;
  String? jwt;


  UserModel({this.user, this.jwt});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    jwt = json['jwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['jwt'] = jwt;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  bool? phoneVerified;
  String? password;
  String? phone;
  String? createdAt;
  String? updatedAt;
  List<String>? roles;

  User(
      {this.id,
      this.name,
      this.email,
      this.phoneVerified,
      this.password,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneVerified = json['phoneVerified'];
    password = json['password'];
    phone = json['phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneVerified'] = phoneVerified;
    data['password'] = password;
    data['phone'] = phone;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['roles'] = roles;
    return data;
  }
}
