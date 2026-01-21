import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.xsoftco.com/api-auth',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
      followRedirects: false,
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<Map<String, dynamic>> register({
    required String name,
    String? phone,
    String? email,
    required String password,
    required String passwordConfirmation,
    required bool agreeTerms,
  }) async {
    final response = await _dio.post(
      '/register.php',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'agree_terms': agreeTerms,
      },
      options: Options(
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
  }) async {
    final response = await _dio.post(
      '/login.php',
      data: {
        'login': login,
        'password': password,
      },
      options: Options(
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }
}
