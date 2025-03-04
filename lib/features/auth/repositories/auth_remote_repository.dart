import 'dart:convert';
import 'dart:developer';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'password': password,
      };
      final response = await http.post(
        Uri.parse("${ServerConstant.serverUrl}/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final resBody = jsonDecode(response.body);
      if (response.statusCode != 201) {
        return Left(AppFailure(resBody['detail']));
      }

      return Right(UserModel.fromMap(resBody));
    } catch (e) {
      log(e.toString());
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> body = {'email': email, 'password': password};
      final response = await http.post(
        Uri.parse("${ServerConstant.serverUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      log(response.body.toString());
      log(response.statusCode.toString());
      final resBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(AppFailure(resBody["detail"]));
      }
      return Right(
        UserModel.fromMap(resBody['user']).copyWith(token: resBody['token']),
      );
    } catch (e) {
      log(e.toString());
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.serverUrl}/auth/"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final resBody = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(AppFailure(resBody["detail"]));
      }
      print("TOKEN ::-- $token");
      return Right(UserModel.fromMap(resBody).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
