import 'dart:convert';

class UserModel {
  final String token;
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email,required this.token});

  UserModel copyWith({String?token, String? name, String? id, String? email,}) {
    return UserModel(
      token: token ?? this.token,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'email': email, 'id': id};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      "UserModel('token' : $token,'id' : $id , 'email' : $email , 'name' : $name)";
}
