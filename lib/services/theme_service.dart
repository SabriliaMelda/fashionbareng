import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  // Ini adalah 'Pengeras Suara' yang akan teriak ke seluruh aplikasi kalau tema berubah
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  // Fungsi simpan pilihan ke HP
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    
    // Update notifier biar aplikasi langsung berubah warnanya
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Fungsi baca pilihan saat aplikasi baru dibuka
  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}