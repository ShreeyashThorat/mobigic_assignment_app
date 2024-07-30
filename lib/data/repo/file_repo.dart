import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobigic_assignment/core/api.dart';
import 'package:mobigic_assignment/data/local%20database/local_db.dart';
import 'package:mobigic_assignment/data/model/media_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/exception/app_exception.dart';

class FileRepo {
  final Api api = Api();
Future<MediaModel> uploadFile(File file) async {
  try {
    final userData = await LocalDatabase.getUserData();
    var data = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path.split("/").last)
    });
    Response response = await api.sendRequest.post("/upload",
        data: data,
        options: Options(headers: {"Authorization": "Bearer ${userData!.token}"}));
    
    if (response.statusCode == 201) {
      if (response.data['status'] == true) {
        final file = MediaModel.fromJson(response.data['data']);
        return file;
      } else {
        throw NotFoundException();
      }
    } else {
      AppExceptionHandler.throwException(null, response.statusCode);
    }
  } on DioException catch (e) {
    if (e.response != null && e.response!.data["message"] != null) {
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


  Future<List<MediaModel>> getFiles() async {
    try {
      final userData = await LocalDatabase.getUserData();
      Response response = await api.sendRequest.get("/my-files",
          options:
              Options(headers: {"Authorization": "Bearer ${userData!.token}"}));
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          final files = (response.data['data'] as List<dynamic>)
              .map((json) => MediaModel.fromJson(json))
              .toList();
          return files;
        } else {
          NotFoundException();
        }
      } else {
        AppExceptionHandler.throwException(null, response.statusCode);
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

  Future<String> deleteFile(int id) async {
    try {
      final user = await LocalDatabase.getUserData();
      Response response = await api.sendRequest.delete(
          "/delete-file?media_id=$id",
          options:
              Options(headers: {"Authorization": "Bearer ${user!.token}"}));
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          return response.data['message'] ?? "File has removed";
        } else {
          NotFoundException();
        }
      } else {
        AppExceptionHandler.throwException(null, response.statusCode);
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

  Future<void> downloadFile(String url, String fileName) async {
    try {
      final Dio dio = Dio();
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final exPath = directory.path;
      await Directory(exPath).create(recursive: true);
      String filePath = '$exPath/$fileName';
      log(filePath);
      await dio.download(url, filePath);
    } on DioException catch (e) {
      AppExceptionHandler.throwException(e);
    } catch (err) {
      log(err.toString());
      AppExceptionHandler.throwException(err);
    }
  }
}
