part of 'app_exception.dart';

class AppExceptionHandler {
  static throwException(Object? error, [int? statusCode]) {
    if (error is SocketException) {
      throw InternetSocketException(error.message);
    } else if (error is DioException) {
      if (error.type == DioExceptionType.connectionError) {
        throw DioConnectionException();
      } else if (error.type == DioExceptionType.connectionTimeout) {
        throw ApiTimeOutException();
      } else if (error.type == DioExceptionType.receiveTimeout) {
        throw ApiTimeOutException();
      } else if (error.type == DioExceptionType.sendTimeout) {
        throw ApiTimeOutException();
      } else if (error.response?.statusCode != null) {
        final statusCode = error.response?.statusCode;
        statusCodeException(statusCode);
      } else {
        throw AppException();
      }
    } else if (error is FormatException) {
      throw DataFormatException(error.message);
    } else if (error is TimeoutException) {
      throw ApiTimeOutException(error.message);
    } else if (error is PlatformException) {
      AppException(title: error.code, message: error.message);
    } else if (error is AppException) {
      throw error;
    } else if (statusCode != null && statusCode != 200) {
      statusCodeException(statusCode);
    } else {
      throw AppException();
    }
  }

  static statusCodeException(int? statusCode) {
    switch (statusCode) {
      case 400:
        throw BadRequestException();
      case 401:
        throw UnAuthorizedException();
      case 403:
        throw ForbiddenException();
      case 404:
        throw NotFoundException();
      case 429:
        throw TooManyRequestException();
      case 500:
        throw InternalServerException();
      case 503:
        throw ServiceUnavailableException();
      default:
        throw AppException(
          exceptionType: 'Dio Exception',
          message: "Something went wrong",
        );
    }
  }
}