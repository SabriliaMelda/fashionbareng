import 'package:dio/dio.dart';

class ApiService {
  // 1. SETUP KONEKSI
  static const String baseUrl = 'http://localhost/api_web_fashion';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  // 2. FUNGSI REGISTER (SEKARANG CUMA 5 PARAMETER)
  Future<Map<String, dynamic>> register(String name, String email, String phone,
      String password, String role) async {
    try {
      final response = await dio.post(
        '/auth/register_worker.php',
        data: FormData.fromMap({
          'full_name': name,
          'email': email,
          'phone_number': phone,
          'password': password,
          'role': role,
          // specialization SUDAH DIHAPUS ❌
        }),
      );
      return response.data;
    } catch (e) {
      if (e is DioException) {
        print("Status: ${e.response?.statusCode}");
        print("Data: ${e.response?.data}");
      }
      throw Exception('Gagal Register: $e');
    }
  }

  // 3. FUNGSI LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login.php',
        data: FormData.fromMap({
          'email': email,
          'password': password,
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Login Gagal: $e');
    }
  }

  // 4. AMBIL DATA PROFIL
  Future<Map<String, dynamic>> getProfile(String id) async {
    try {
      final response = await dio.get('/auth/get_profile.php?id=$id');
      return response.data;
    } catch (e) {
      throw Exception('Gagal ambil profil: $e');
    }
  }

  // 5. UPDATE PROFIL (SEKARANG CUMA 4 PARAMETER)
  Future<Map<String, dynamic>> updateProfile(
      String id, String name, String email, String phone) async {
    try {
      final response = await dio.post(
        '/auth/update_profile.php',
        data: FormData.fromMap({
          'id': id,
          'full_name': name,
          'email': email,
          'phone_number': phone,
          // specialization SUDAH DIHAPUS ❌
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Gagal update profil: $e');
    }
  }

  // --- FUNGSI LAINNYA (Material, Password, dll tetap sama) ---

  Future<List<dynamic>> getMaterials() async {
    try {
      final response = await dio.get('/materials/list_materials.php');
      if (response.data['status'] == 'success') {
        return response.data['data'];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Gagal mengambil data material: $e');
    }
  }

  Future<Map<String, dynamic>> updateMaterial(String id, String name,
      String stock, String price, String imageUrl) async {
    try {
      final response = await dio.post(
        '/materials/edit_material.php',
        data: FormData.fromMap({
          'id': id,
          'material_name': name,
          'stock_quantity': stock,
          'price_per_unit': price,
          'image_url': imageUrl,
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Gagal update material: $e');
    }
  }

  Future<Map<String, dynamic>> restockMaterial(String id, String amount) async {
    try {
      final response = await dio.post(
        '/materials/restock_material.php',
        data: FormData.fromMap({
          'id': id,
          'amount': amount,
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Restock gagal: $e');
    }
  }

  Future<Map<String, dynamic>> addMaterial(String name, String stock,
      String unit, String price, String category, String image) async {
    try {
      final response = await dio.post(
        '/materials/add_material.php',
        data: FormData.fromMap({
          'material_name': name,
          'stock_quantity': stock,
          'unit': unit,
          'price_per_unit': price,
          'category': category,
          'image_url': image,
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Gagal tambah barang: $e');
    }
  }

  Future<Map<String, dynamic>> changePassword(
      String id, String oldPass, String newPass) async {
    try {
      final response = await dio.post(
        '/auth/change_password.php',
        data: FormData.fromMap({
          'id': id,
          'old_password': oldPass,
          'new_password': newPass,
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Gagal ubah password: $e');
    }
  }
}
