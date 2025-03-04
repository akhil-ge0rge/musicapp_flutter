// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:client/features/home/model/favorite_song_model.dart';

class UserModel {
  final String token;
  final String id;
  final String name;
  final String email;
  final List<FavoriteSongModel> favorites;

  UserModel({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.favorites,
  });

  UserModel copyWith({
    String? token,
    String? id,
    String? name,
    String? email,
    List<FavoriteSongModel>? favorites,
  }) {
    return UserModel(
      token: token ?? this.token,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      favorites: favorites ?? this.favorites,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'favorites': favorites.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      favorites: List<FavoriteSongModel>.from(
        (map['favorites'] ?? []).map<FavoriteSongModel>(
          (x) => FavoriteSongModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(token: $token, id: $id, name: $name, email: $email, favorites: $favorites)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        listEquals(other.favorites, favorites);
  }

  @override
  int get hashCode {
    return token.hashCode ^
        id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        favorites.hashCode;
  }
}
