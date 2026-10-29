import 'package:dio/dio.dart';

/// The only error type the UI ever sees. Raw [DioException]s stay in the data layer.
class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  factory AppException.fromDio(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const AppException('The server took too long to respond.'),
    DioExceptionType.connectionError => const AppException('No internet connection.'),
    DioExceptionType.badResponse => AppException(
      _serverMessage(e.response) ?? 'Something went wrong (${e.response?.statusCode}).',
      statusCode: e.response?.statusCode,
    ),
    DioExceptionType.cancel => const AppException('Request cancelled.'),
    _ => const AppException('Something went wrong. Please try again.'),
  };

  final String message;
  final int? statusCode;

  /// NestJS error bodies look like `{ statusCode, message, error }`;
  /// `message` is a list when validation pipes fail.
  static String? _serverMessage(Response<dynamic>? response) {
    final data = response?.data;
    if (data is! Map) return null;
    final message = data['message'];
    if (message is String) return message;
    if (message is List && message.isNotEmpty) return message.first.toString();
    return null;
  }

  @override
  String toString() => message;
}

/// Wraps a repository call so transport errors surface as [AppException].
Future<T> guardDio<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw AppException.fromDio(e);
  }
}
