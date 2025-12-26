import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(String name);
  Future<UserModel?> getUserById(String id);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _usersKey = 'users';
  final SharedPreferences sharedPreferences;
  final Uuid _uuid = const Uuid();

  UserLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final usersJson = sharedPreferences.getString(_usersKey);
      if (usersJson == null || usersJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> usersList = json.decode(usersJson);
      return usersList
          .map((userJson) => UserModel.fromJson(userJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<UserModel> addUser(String name) async {
    try {
      final users = await getUsers();
      
      final newUser = UserModel(
        id: _uuid.v4(),
        name: name,
        isOnline: true,
        lastSeen: DateTime.now(),
      );
      
      users.add(newUser);
      
      final usersJson = json.encode(
        users.map((user) => user.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_usersKey, usersJson);
      
      return newUser;
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      final users = await getUsers();
      return users.firstWhere(
        (user) => user.id == id,
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      return null;
    }
  }
}
