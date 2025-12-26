import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.isOnline,
    super.lastSeen,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      isOnline: user.isOnline,
      lastSeen: user.lastSeen,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      isOnline: isOnline,
      lastSeen: lastSeen,
    );
  }
}
