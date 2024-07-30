import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mobigic_assignment/core/api.dart';

import '../../utils/exception/app_exception.dart';
import '../local database/local_db.dart';
import '../model/user model/user_model.dart';

class AuthRepo {
  final Api api = Api();

  Future<UserModel> login(String email, String password) async {
    try {
      Response response = await api.sendRequest.post("/login",
          data: jsonEncode({"email": email, "password": password}));
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          final userData = UserModel.fromJson(response.data['data']);
          await LocalDatabase.saveUserData(userData);
          return userData;
        }
      }
    } on DioException catch (e) {
      if (e.response!.data["message"] != null) {
        throw AppException(
            message: "${e.response!.data["message"]}",
            statusCode: e.response!.statusCode ?? 0);
      } else {
        AppExceptionHandler.throwException(e);
      }
    } catch (err) {
      log(err.toString());
      AppExceptionHandler.throwException(err);
    }
    throw AppException();
  }

  Future<UserModel> register(String email, String firstname, String lastname,
      String dob, String password) async {
    try {
      Response response = await api.sendRequest.post("/create-user",
          data: jsonEncode({
            "email": email,
            "firstName": firstname,
            "lastName": lastname,
            "password": password,
            "dob": dob
          }));
      if (response.statusCode == 201) {
        if (response.data['status'] == true) {
          final userData = UserModel.fromJson(response.data['data']);
          await LocalDatabase.saveUserData(userData);
          return userData;
        }
      }
    } on DioException catch (e) {
      AppExceptionHandler.throwException(e);
    } catch (err) {
      log(err.toString());
      AppExceptionHandler.throwException(err);
    }
    throw AppException();
  }
}
