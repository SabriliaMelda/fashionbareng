import 'package:dio/dio.dart';

class ApiService {
  // 1. SETUP KONEKSI (Pakai Style Dio Temanmu)

  // ⚠️ Ganti IP ini dengan IP Laptop kamu yang didapat dari ipconfig
  // Jangan pakai port 8000 kalau pakai XAMPP biasa (kecuali kamu ubah port apache)
  static const String baseUrl = 'http://localhost/api_web_fashion';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json', // PHP kita mereturn JSON
        // 'Content-Type': 'application/x-www-form-urlencoded' // Kadang PHP butuh ini untuk POST biasa
      },
    ),
  );

  // 2. FUNGSI-FUNGSI (Logika Aplikasi)

  // --- FUNGSI REGISTER BARU (SESUAI REQUEST KAMU) ---
  Future<Map<String, dynamic>> register(String name, String email, String phone,
      String password, String role, String specialization) async {
    try {
      // Perhatikan path ini: sesuaikan dengan nama file PHP yang kamu upload
      // Kamu mengupload 'register_worker.php', jadi kita tembak ke sana.
      final response = await dio.post(
        '/auth/register_worker.php',
        data: FormData.fromMap({
          'full_name': name,
          'email': email,
          'phone_number': phone,
          'password': password,
          'role': role, // Wajib ada biar PHP gak crash
          'specialization': specialization, // Wajib ada biar PHP gak crash
        }),
      );
      return response.data;
    } catch (e) {
      // Debugging: Cek error jika PHP membalas HTML
      if (e is DioException) {
        print("Status: ${e.response?.statusCode}");
        print("Data: ${e.response?.data}");
      }
      throw Exception('Gagal Register: $e');
    }
  }

  // Contoh Fungsi Login pakai Dio
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Dio otomatis menganggap ini POST ke: http://192.168.../auth/login.php
      // Dio pakai FormData secara otomatis untuk body
      final response = await dio.post(
        '/auth/login.php',
        data: FormData.fromMap({
          'email': email,
          'password': password,
        }),
      );

      return response
          .data; // Dio otomatis mengubah JSON jadi Map, gak perlu json.decode lagi
    } catch (e) {
      throw Exception('Login Gagal: $e');
    }
  }

  // Ambil Data Profil Terbaru
  Future<Map<String, dynamic>> getProfile(String id) async {
    try {
      final response = await dio
          .get('/auth/get_profile.php?id=$id'); // Sesuaikan path folder
      return response.data;
    } catch (e) {
      throw Exception('Gagal ambil profil: $e');
    }
  }

  // Update Data Profil
  Future<Map<String, dynamic>> updateProfile(
      String id, String name, String email, String phone, String spec) async {
    try {
      final response = await dio.post(
        '/auth/update_profile.php', // Sesuaikan path folder
        data: FormData.fromMap({
          'id': id,
          'full_name': name,
          'email': email,
          'phone_number': phone,
          'specialization': spec,
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Gagal update profil: $e');
    }
  }

  // Fungsi Ambil List Bahan Baku
  Future<List<dynamic>> getMaterials() async {
    try {
      final response = await dio.get('/materials/list_materials.php');

      // Cek apakah response sukses
      if (response.data['status'] == 'success') {
        return response.data['data']; // Kembalikan List-nya saja
      } else {
        return []; // Kalau gagal/kosong, kembalikan list kosong
      }
    } catch (e) {
      throw Exception('Gagal mengambil data material: $e');
    }
  }

  // Update Material
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

  // Fungsi Restock (Tambah Stok)
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

  // Fungsi Tambah Barang Baru
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
      print("Error Add Material: $e");
      throw Exception('Gagal tambah barang: $e');
    }
  }

  // Fungsi Ubah Password
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
