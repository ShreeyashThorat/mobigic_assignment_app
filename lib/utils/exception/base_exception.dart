part of 'app_exception.dart';

class AppException implements Exception {
  final String? title;
  final String? message;
  final String? lottiePath;
  final String? imagePath;
  final String? exceptionType;
  final int? statusCode;

  AppException(
      {this.title = 'Error',
      this.message = 'Something went wrong',
      this.lottiePath,
      this.imagePath,
      this.exceptionType = 'App Exception',
      this.statusCode = 0});
  @override
  String toString() {
    return "title : $title  message: $message ${lottiePath == null ? "" : "\nlottiePath: $lottiePath"} ${imagePath == null ? "" : "\nlottiePath: $imagePath"} ${statusCode == 0 ? "" : "\nstatusCode: $statusCode"}";
  }

  get print {
    ColoredLog('****************', name: exceptionType);
    if (title != null) {
      ColoredLog.red(title, name: 'title');
    }
    if (message != null) {
      ColoredLog.red(message, name: 'message');
    }
    if (lottiePath != null) {
      ColoredLog.red(lottiePath, name: 'lottiePath');
    }
    if (imagePath != null) {
      ColoredLog.red(imagePath, name: 'imagePath');
    }
    ColoredLog('****************', name: exceptionType);
  }
}