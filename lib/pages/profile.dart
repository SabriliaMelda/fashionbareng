// lib/pages/profile.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashion_mobile/services/api_service.dart';
import 'package:fashion_mobile/pages/login.dart';
import 'home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ===== Tokens (PURPLE) =====
  static const _purple = Color(0xFF6B257F);
  static const _purple2 = Color(0xFF8B5CF6);

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();

  // ❌ Controller Role & Spesialisasi DIHAPUS

  String? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 1. FUNGSI AMBIL DATA
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('userId');

      if (_userId != null) {
        final response = await ApiService().getProfile(_userId!);
        final data = response['data'];

        setState(() {
          _nameC.text = data['full_name'] ?? '';
          _emailC.text = data['email'] ?? '';
          _phoneC.text = data['phone_number'] ?? '';
          // Kita abaikan data role & specialization dari server
        });

        await prefs.setString('userName', data['full_name']);
      }
    } catch (e) {
      _toast("Gagal memuat profil: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 2. FUNGSI SIMPAN (Trik Backend)
  Future<void> _saveProfile() async {
    if (_userId == null) return;

    setState(() => _isLoading = true);
    try {
      // ✅ HARDCODE 'Owner'
      // Backend update_profile.php mewajibkan parameter ke-5 (specialization).
      // Kita kirim string "Owner" agar backend tetap jalan, tapi user tidak perlu melihatnya.
      await ApiService().updateProfile(
        _userId!,
        _nameC.text,
        _emailC.text,
        _phoneC.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameC.text);

      _toast("Profil berhasil diperbarui!");
    } catch (e) {
      _toast("Gagal update: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    }
  }

  void _showChangePasswordDialog() {
    final oldPassC = TextEditingController();
    final newPassC = TextEditingController();
    final confirmPassC = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgPopup = isDark ? const Color(0xFF1F2937) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: bgPopup,
              title: Text("Ubah Password",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: textColor)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PopupInput(
                        controller: oldPassC,
                        label: "Password Lama",
                        obscure: obscureOld,
                        isDark: isDark,
                        onToggle: () =>
                            setState(() => obscureOld = !obscureOld)),
                    const SizedBox(height: 10),
                    _PopupInput(
                        controller: newPassC,
                        label: "Password Baru",
                        obscure: obscureNew,
                        isDark: isDark,
                        onToggle: () =>
                            setState(() => obscureNew = !obscureNew)),
                    const SizedBox(height: 10),
                    _PopupInput(
                        controller: confirmPassC,
                        label: "Konfirmasi Password",
                        obscure: obscureNew,
                        isDark: isDark),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _purple),
                  onPressed: () async {
                    if (oldPassC.text.isEmpty || newPassC.text.isEmpty) {
                      _toast("Semua kolom harus diisi");
                      return;
                    }
                    if (newPassC.text != confirmPassC.text) {
                      _toast("Konfirmasi password tidak cocok");
                      return;
                    }
                    if (newPassC.text.length < 6) {
                      _toast("Password minimal 6 karakter");
                      return;
                    }

                    try {
                      Navigator.pop(context);
                      final response = await ApiService().changePassword(
                          _userId!, oldPassC.text, newPassC.text);

                      if (response['status'] == 'success') {
                        _toast(
                            "Password berhasil diubah! Silakan login ulang.");
                        _logout();
                      } else {
                        _toast(response['message']);
                      }
                    } catch (e) {
                      _toast("Error: $e");
                    }
                  },
                  child: const Text("Simpan",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7FAFF);
    final Color ink = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color muted =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color cardColor =
        isDark ? const Color(0xFF1F2937) : const Color(0xCCFFFFFF);
    final Color borderColor = isDark ? Colors.white12 : const Color(0x1A0F172A);
    final Color inputFill =
        isDark ? const Color(0xFF374151) : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          _GradientBackdropPurple(isDark: isDark),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: _purple)),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              children: [
                // ===== Header =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIcon(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                      isDark: isDark,
                    ),
                    Text(
                      'Profil Owner', // Ganti jadi Profil Owner
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Encode Sans',
                        fontWeight: FontWeight.w700,
                        color: ink,
                        height: 1.2,
                      ),
                    ),
                    _CircleIcon(
                      icon: Icons.home_filled,
                      iconColor: _purple,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      isDark: isDark,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== Profile Card =====
                _GlassCard(
                  color: cardColor,
                  borderColor: borderColor,
                  child: Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF3E8FF), Color(0xFFFFFFFF)],
                          ),
                          border: Border.all(color: borderColor),
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: _purple, size: 34),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameC.text.isEmpty ? 'Loading...' : _nameC.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ink,
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // ❌ Hapus Tampilan Role di sini
                            // Ganti dengan Email saja
                            Text(
                              _emailC.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _SectionTitle(
                  title: 'Data Bisnis',
                  subtitle: 'Informasi akun pemilik',
                  textColor: ink,
                  subColor: muted,
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  color: cardColor,
                  borderColor: borderColor,
                  child: Column(
                    children: [
                      _InputField(
                        accent: _purple,
                        controller: _nameC,
                        label: 'Nama Pemilik',
                        hint: 'Nama Lengkap',
                        icon: Icons.badge_outlined,
                        fillColor: inputFill,
                        textColor: ink,
                        hintColor: muted,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 10),
                      _InputField(
                        accent: _purple,
                        controller: _emailC,
                        label: 'Email Bisnis',
                        hint: 'email@contoh.com',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        fillColor: inputFill,
                        textColor: ink,
                        hintColor: muted,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 10),
                      _InputField(
                        accent: _purple,
                        controller: _phoneC,
                        label: 'No. HP / WhatsApp',
                        hint: '0812...',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                        fillColor: inputFill,
                        textColor: ink,
                        hintColor: muted,
                        borderColor: borderColor,
                      ),

                      // ❌ FIELD JABATAN & SPESIALISASI SUDAH HILANG TOTAL

                      const SizedBox(height: 12),

                      // Save button
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: _isLoading ? null : _saveProfile,
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border:
                                Border.all(color: _purple.withOpacity(0.18)),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_purple, _purple2],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A6B257F),
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: Text(
                            _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _SectionTitle(
                  title: 'Keamanan',
                  subtitle: 'Pengaturan akses',
                  textColor: ink,
                  subColor: muted,
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  color: cardColor,
                  borderColor: borderColor,
                  child: Column(
                    children: [
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.lock_reset_rounded,
                        title: 'Ubah Password',
                        subtitle: 'Amankan akun bisnis anda',
                        onTap: _showChangePasswordDialog,
                        tileColor: inputFill,
                        borderColor: borderColor,
                        textColor: ink,
                        subColor: muted,
                      ),
                      _DividerSoft(color: borderColor),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.logout_rounded,
                        title: 'Keluar Aplikasi',
                        subtitle: 'Akhiri sesi',
                        danger: true,
                        onTap: _logout,
                        tileColor: inputFill,
                        borderColor: borderColor,
                        textColor: ink,
                        subColor: muted,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== WIDGET PENDUKUNG (TETAP SAMA) =====

class _GradientBackdropPurple extends StatelessWidget {
  final bool isDark;
  const _GradientBackdropPurple({required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (isDark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF070A12), Color(0xFF0B1220), Color(0xFF0F172A)],
          ),
        ),
        child: Stack(
          children: const [
            Positioned(
                top: -60,
                right: -40,
                child: _BlurBlob(size: 220, color: Color(0x223B82F6))),
            Positioned(
                bottom: -80,
                left: -60,
                child: _BlurBlob(size: 260, color: Color(0x224C1D95))),
          ],
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDF4FF), Color(0xFFF8FAFC), Color(0xFFF3E8FF)],
        ),
      ),
      child: Stack(
        children: const [
          Positioned(
              top: -60,
              right: -40,
              child: _BlurBlob(size: 220, color: Color(0x556B257F))),
          Positioned(
              bottom: -80,
              left: -60,
              child: _BlurBlob(size: 260, color: Color(0x338B5CF6))),
        ],
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _BlurBlob({required this.size, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  const _GlassCard(
      {required this.child, required this.color, required this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(
                color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 12))
          ]),
      child: child,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool isDark;
  const _CircleIcon(
      {required this.icon,
      required this.onTap,
      this.iconColor,
      required this.isDark});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: isDark ? Colors.white12 : const Color(0x220F172A)),
            color: isDark ? const Color(0xFF1F2937) : Colors.white),
        alignment: Alignment.center,
        child: Icon(icon,
            size: 20,
            color:
                iconColor ?? (isDark ? Colors.white : const Color(0xFF0F172A))),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subColor;
  const _SectionTitle(
      {required this.title,
      required this.subtitle,
      required this.textColor,
      required this.subColor});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w900)),
      const SizedBox(height: 4),
      Text(subtitle,
          style: TextStyle(
              color: subColor,
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600)),
    ]);
  }
}

class _DividerSoft extends StatelessWidget {
  final Color color;
  const _DividerSoft({required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(height: 1, thickness: 1, color: color));
  }
}

class _InputField extends StatelessWidget {
  final Color accent;
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool readOnly;
  final Color fillColor;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;

  const _InputField(
      {required this.accent,
      required this.controller,
      required this.label,
      required this.hint,
      required this.icon,
      this.keyboardType = TextInputType.text,
      this.readOnly = false,
      required this.fillColor,
      required this.textColor,
      required this.hintColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(
              color: hintColor,
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: TextStyle(
            color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: accent),
          hintText: hint,
          hintStyle: TextStyle(
              color: hintColor.withOpacity(0.5),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600),
          filled: true,
          fillColor: fillColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: borderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: borderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: accent)),
        ),
      ),
    ]);
  }
}

class _PopupInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback? onToggle;
  final bool isDark;
  const _PopupInput(
      {required this.controller,
      required this.label,
      this.obscure = false,
      this.onToggle,
      required this.isDark});
  @override
  Widget build(BuildContext context) {
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color hintColor = isDark ? Colors.white54 : Colors.black54;
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: hintColor)),
        suffixIcon: onToggle != null
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                    color: hintColor),
                onPressed: onToggle)
            : null,
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;
  final Color tileColor;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _MenuRow(
      {required this.accent,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.danger = false,
      required this.tileColor,
      required this.borderColor,
      required this.textColor,
      required this.subColor});

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFEF4444) : accent;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: tileColor,
                  border: Border.all(color: borderColor)),
              child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: TextStyle(
                        color: danger ? const Color(0xFFEF4444) : textColor,
                        fontSize: 12.5,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: subColor,
                        fontSize: 11.5,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600)),
              ])),
          Icon(Icons.chevron_right_rounded, color: subColor),
        ]),
      ),
    );
  }
}
