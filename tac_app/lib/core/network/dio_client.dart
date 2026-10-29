import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tac_app/core/env/env.dart';
import 'package:tac_app/core/storage/token_storage.dart';

/// The one shared HTTP client. Never create `Dio()` in a widget or repository.
final dioProvider = Provider<Dio>((ref) {
  if (Env.isProd && !Env.apiBaseUrl.startsWith('https://')) {
    throw StateError('Production API_BASE_URL must use HTTPS.');
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(AuthInterceptor(ref.watch(tokenStorageProvider)));
  if (kDebugMode && Env.enableHttpLogs) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false, // keeps the Authorization header out of logs
        requestBody: true,
        responseBody: true,
        logPrint: (line) => debugPrint(line.toString()),
      ),
    );
  }

  ref.onDispose(dio.close);
  return dio;
});

/// Adds the bearer token to every request and drops it when the server says 401.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final TokenStorage _tokens;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokens.readAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO(auth): refresh-token flow once the NestJS Auth module issues JWTs.
    if (err.response?.statusCode == 401) await _tokens.clear();
    handler.next(err);
  }
}
