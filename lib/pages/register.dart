import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fashion_mobile/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Toggle: true = telepon, false = email
  bool _usePhone = true;

  // Controllers (Hanya data diri dasar)
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // ❌ Controller Spesialisasi DIHAPUS

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;

    if (!_agree) {
      _toast('Silakan setujui syarat dan ketentuan.');
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passController.text;
    final confirm = _confirmPassController.text;

    // Validasi
    if (name.isEmpty) {
      _toast('Nama wajib diisi');
      return;
    }
    if (_usePhone && phone.isEmpty) {
      _toast('No HP wajib diisi');
      return;
    }
    if (!_usePhone && email.isEmpty) {
      _toast('Email wajib diisi');
      return;
    }
    if (password.length < 6) {
      _toast('Password min 6 karakter');
      return;
    }
    if (password != confirm) {
      _toast('Konfirmasi password beda');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final finalEmail = _usePhone ? '' : email;
      final finalPhone = _usePhone ? phone : '';

      // ✅ SETTING OTOMATIS UNTUK PEMILIK BISNIS
      // Backend PHP tetap butuh data ini, jadi kita isi otomatis di balik layar.
      const defaultRole = 'owner';
      const defaultSpecialization = 'Owner';

      final result = await ApiService().register(
        name,
        finalEmail,
        finalPhone,
        password,
        defaultRole,
      );

      if (result['status'] == 'success') {
        _toast("Registrasi Berhasil! Silakan Login.");
        if (mounted) Navigator.pop(context);
      } else {
        _toast(result['message'] ?? 'Gagal mendaftar');
      }
    } catch (e) {
      _toast("Gagal koneksi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _isLoading ? null : () => Navigator.pop(context),
                child: Container(
                  width: 41,
                  height: 41,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8ECF4))),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 18, color: Color(0xFF1E232C)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Hello! Register to get started',
                  style: TextStyle(
                      color: Color(0xFF1E232C),
                      fontSize: 30,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3)),
              const SizedBox(height: 32),

              _inputField(controller: _nameController, hint: 'Nama Lengkap'),
              const SizedBox(height: 16),

              // ❌ Input Spesialisasi SUDAH HILANG DARI SINI

              _usePhone
                  ? _phoneField(
                      controller: _phoneController, hint: '081xxxxxxxx')
                  : _inputField(
                      controller: _emailController,
                      hint: 'johndoe@contoh.com',
                      keyboardType: TextInputType.emailAddress),

              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => _usePhone = !_usePhone),
                child: Text(_usePhone ? '*Gunakan Email' : '*Gunakan No HP',
                    style: const TextStyle(
                        color: Color(0xFF6B257F),
                        fontSize: 12,
                        decoration: TextDecoration.underline)),
              ),

              const SizedBox(height: 16),
              _inputField(
                  controller: _passController,
                  hint: 'Kata sandi',
                  isPassword: true,
                  obscure: _obscurePass,
                  onToggleObscure: () =>
                      setState(() => _obscurePass = !_obscurePass)),
              const SizedBox(height: 16),
              _inputField(
                  controller: _confirmPassController,
                  hint: 'Konfirmasi Sandi',
                  isPassword: true,
                  obscure: _obscureConfirm,
                  onToggleObscure: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm)),

              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                      value: _agree,
                      activeColor: const Color(0xFF6B257F),
                      onChanged: (val) =>
                          setState(() => _agree = val ?? false)),
                  const Expanded(
                      child: Text('Saya menyetujui Syarat & Ketentuan',
                          style:
                              TextStyle(fontSize: 13, fontFamily: 'Urbanist'))),
                ],
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C2580),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                        text: 'Login Now',
                        style: TextStyle(
                            color: Color(0xFF6B257F),
                            fontWeight: FontWeight.w700))
                  ])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
      {required TextEditingController controller,
      required String hint,
      bool isPassword = false,
      bool obscure = false,
      VoidCallback? onToggleObscure,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8ECF4))),
      child: Row(children: [
        Expanded(
            child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: isPassword ? obscure : false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(
                        color: Color(0xFF8390A1), fontSize: 15)))),
        if (isPassword)
          GestureDetector(
              onTap: onToggleObscure,
              child: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF8390A1))),
      ]),
    );
  }

  Widget _phoneField(
      {required TextEditingController controller, required String hint}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8ECF4))),
      child: Row(children: [
        const Text('+62', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        Container(width: 1, height: 22, color: const Color(0xFFE8ECF4)),
        const SizedBox(width: 10),
        Expanded(
            child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(
                        color: Color(0xFF8390A1), fontSize: 15)))),
      ]),
    );
  }
}
