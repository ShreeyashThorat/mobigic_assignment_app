import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../colored_log.dart';

part 'base_exception.dart';
part 'exception_handler.dart';

class AuthenticationException extends AppException {
  AuthenticationException({
    super.title = 'Authentication Failed',
    super.message = 'Authentication Failed, try again',
    super.exceptionType = 'Auth Exception',
  });
}

class InternetSocketException extends AppException {
  final String? errorMessage;
  InternetSocketException(this.errorMessage)
      : super(
          title: 'Network Problem',
          message: errorMessage ??
              'There is some issue with your wifi or your mobile internet',
          exceptionType: 'Internet Error',
        );
}

class ApiHttpExceptionException extends AppException {
  final String? errorMessage;
  ApiHttpExceptionException(this.errorMessage)
      : super(
          title: 'Network Problem',
          message: errorMessage,
          exceptionType: 'Api Error',
        );
}

class DataFormatException extends AppException {
  final String? errorMessage;
  DataFormatException(this.errorMessage)
      : super(
          title: 'Format Exception',
          message: errorMessage,
          exceptionType: 'Format Exception',
        );
}

class ApiTimeOutException extends AppException {
  ApiTimeOutException([String? message])
      : super(
          title: 'TimeOut Exception',
          message: "Timeout Error: Operation exceeded expected duration. Retry",
          exceptionType: 'TimeOut Error',
        );
}

class BadRequestException extends AppException {
  BadRequestException()
      : super(
          title: 'Bad Request',
          message: 'Your request is invalid.',
          exceptionType: 'BadRequestException',
        );
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(
          title: 'Unauthorized',
          message: 'Incorrect userid or password!',
          exceptionType: 'UnAuthorizedException',
        );
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message, String? url])
      : super(
          title: 'Forbidden',
          message: 'Invalid authentication token!',
          exceptionType: 'ForbiddenException',
        );
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(
            title: 'Not Found',
            message: 'No Results Found!',
            exceptionType: 'Not Found',
            statusCode: 404);
}

class TooManyRequestException extends AppException {
  TooManyRequestException([String? message, String? url])
      : super(
          title: 'Too Many Requests',
          message:
              'You have made more requests per second than you are allowed.',
          exceptionType: 'TooManyRequestException',
        );
}

class InternalServerException extends AppException {
  InternalServerException([String? message, String? url])
      : super(
          title: 'Internal Server Error',
          message: 'We had a problem with our server. Try again later.',
          exceptionType: 'InternalServerException',
        );
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String? message, String? url])
      : super(
          title: 'Service Unavailable',
          message:
              "We're temporarily offline for maintenance. Please try again later.",
          exceptionType: 'ServiceUnavailableException',
        );
}

class LocationNotFound extends AppException {
  LocationNotFound({
    super.title = 'Location Not Found',
    super.message = 'We couldn\'t find the location your are searching for',
  }) : super(
          exceptionType: 'LocationNotFoundException',
        );
}

class DioConnectionException extends AppException {
  DioConnectionException({
    super.title = 'Dio Connection Error',
    super.message = 'There was an issue connecting to the server',
  }) : super(
          exceptionType: 'DioConnectionException',
        );
}