import 'package:flutter/material.dart';
import 'package:fashion_mobile/pages/login.dart';
import 'package:fashion_mobile/pages/home.dart';
import 'package:fashion_mobile/services/theme_service.dart'; // Import service baru
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load Tema Pilihan User sebelum aplikasi jalan
  await ThemeService.loadTheme();

  // Cek status login
  final prefs = await SharedPreferences.getInstance();
  final isLogin = prefs.getBool('isLogin') ?? false;

  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    // 2. Bungkus MaterialApp dengan Builder ini agar bisa ganti tema Live
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Konveksi App',
          
          // --- TEMA TERANG (LIGHT) ---
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xFF6B257F),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B257F),
              secondary: Color(0xFF8B5CF6),
            ),
            fontFamily: 'Plus Jakarta Sans',
            useMaterial3: true,
          ),

          // --- TEMA GELAP (DARK) ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF111827), // Warna background gelap
            primaryColor: const Color(0xFF8B5CF6),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8B5CF6),
              secondary: Color(0xFF6B257F),
              surface: Color(0xFF1F2937), // Warna kartu/card di mode gelap
            ),
            fontFamily: 'Plus Jakarta Sans',
            useMaterial3: true,
          ),

          // Mode aktif (Light/Dark/System)
          themeMode: currentMode,

          home: isLogin ? const HomeScreen() : const Login(),
        );
      },
    );
  }
}