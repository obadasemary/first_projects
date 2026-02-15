import 'package:dio/dio.dart';

String handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timeout. Please try again.';
    case DioExceptionType.receiveTimeout:
      return 'Server not responding. Please try again.';
    case DioExceptionType.badResponse:
      return 'Server error: ${e.response?.statusCode}. Please try again later.';
    case DioExceptionType.connectionError:
      return 'No internet connection. Please check your network.';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    default:
      return 'Network error occurred. Please try again.';
  }
}
