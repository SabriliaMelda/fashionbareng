import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.13.32.56/api-auth', // GANTI sesuai IPv4 laptop
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
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
    try {
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
          contentType: Headers.jsonContentType, // PENTING: paksa JSON
        ),
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      // debug detail
      print("=== DIO ERROR ===");
      print("TYPE: ${e.type}");
      print("URI: ${e.requestOptions.uri}");
      print("MSG: ${e.message}");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      rethrow;
    }
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
