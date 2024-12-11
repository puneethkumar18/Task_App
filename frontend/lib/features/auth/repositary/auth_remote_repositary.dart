import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/services/sp_services.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepositary {
  final spServices = SpServices();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res =
          await http.post(Uri.parse('${Constants.backendUri}/auth/signUp'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'name': name,
                'email': email,
                'password': password,
              }));
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/LogIn'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spServices.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/isTokenValid'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }
      final userData = await http.get(
        Uri.parse('${Constants.backendUri}/auth'),
        headers: {
          'Content-Type': 'applicatio/json',
          'x-auth-token': token,
        },
      );
      if (userData.statusCode != 200) {
        return null;
      }
      return UserModel.fromJson(userData.body);
    } catch (e) {
      return null;
    }
  }
}
