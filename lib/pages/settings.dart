// settings.dart
import 'package:flutter/material.dart';
import 'home.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ===== Theme tokens (PURPLE) =====
  static const _purple = Color(0xFF6B257F); // main accent (ungu)
  static const _purple2 = Color(0xFF8B5CF6); // secondary accent (ungu muda)
  static const _ink = Color(0xFF0F172A); // slate-900
  static const _muted = Color(0xFF64748B); // slate-500
  static const _border = Color(0x1A0F172A);
  static const _card = Color(0xCCFFFFFF); // glass-ish white

  // ===== Dummy states =====
  bool _notif = true;
  bool _darkMode = false;
  bool _biometric = false;
  bool _autoBackup = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: Stack(
        children: [
          const _GradientBackdropPurple(),

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
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Encode Sans',
                        fontWeight: FontWeight.w700,
                        color: _ink,
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
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== Account card =====
                _GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF3E8FF), Color(0xFFFFFFFF)],
                          ),
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(Icons.person_rounded, color: _purple, size: 30),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IT BDN',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _ink,
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Admin • bdn@company.com (dummy)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _muted,
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(
                        text: 'Edit',
                        color: _purple,
                        onTap: () => _toast(context, 'Edit profil (dummy)'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===== Quick toggles =====
                const _SectionTitle(
                  title: 'Preferensi',
                  subtitle: 'Pengaturan cepat untuk aplikasi',
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  child: Column(
                    children: [
                      _SwitchRow(
                        accent: _purple,
                        icon: Icons.notifications_active_outlined,
                        title: 'Notifikasi',
                        subtitle: 'Reminder & update status',
                        value: _notif,
                        onChanged: (v) => setState(() => _notif = v),
                      ),
                      const _DividerSoft(),
                      _SwitchRow(
                        accent: _purple,
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Tema gelap (dummy)',
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),
                      const _DividerSoft(),
                      _SwitchRow(
                        accent: _purple,
                        icon: Icons.fingerprint_rounded,
                        title: 'Biometrik',
                        subtitle: 'Fingerprint / Face ID (dummy)',
                        value: _biometric,
                        onChanged: (v) => setState(() => _biometric = v),
                      ),
                      const _DividerSoft(),
                      _SwitchRow(
                        accent: _purple,
                        icon: Icons.cloud_sync_outlined,
                        title: 'Auto Backup',
                        subtitle: 'Simpan otomatis (dummy)',
                        value: _autoBackup,
                        onChanged: (v) => setState(() => _autoBackup = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ===== Settings list =====
                const _SectionTitle(
                  title: 'Umum',
                  subtitle: 'Kelola akun, keamanan, dan tampilan',
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  child: Column(
                    children: [
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.person_outline_rounded,
                        title: 'Profil',
                        subtitle: 'Nama, foto, kontak',
                        onTap: () => _toast(context, 'Profil (dummy)'),
                      ),
                      const _DividerSoft(),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.lock_outline_rounded,
                        title: 'Keamanan',
                        subtitle: 'PIN, password, perangkat',
                        onTap: () => _toast(context, 'Keamanan (dummy)'),
                      ),
                      const _DividerSoft(),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.language_rounded,
                        title: 'Bahasa',
                        subtitle: 'Indonesia',
                        onTap: () => _toast(context, 'Bahasa (dummy)'),
                      ),
                      const _DividerSoft(),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.palette_outlined,
                        title: 'Tema & Tampilan',
                        subtitle: 'Warna, font, layout',
                        onTap: () => _toast(context, 'Tema (dummy)'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const _SectionTitle(
                  title: 'Bantuan',
                  subtitle: 'Info & dukungan',
                ),
                const SizedBox(height: 10),

                _GlassCard(
                  child: Column(
                    children: [
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.help_outline_rounded,
                        title: 'Pusat Bantuan',
                        subtitle: 'FAQ & panduan',
                        onTap: () => _toast(context, 'Pusat Bantuan (dummy)'),
                      ),
                      const _DividerSoft(),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi',
                        subtitle: 'Data & penggunaan',
                        onTap: () => _toast(context, 'Kebijakan Privasi (dummy)'),
                      ),
                      const _DividerSoft(),
                      _MenuRow(
                        accent: _purple,
                        icon: Icons.info_outline_rounded,
                        title: 'Tentang Aplikasi',
                        subtitle: 'Versi, build, lisensi',
                        onTap: () => _toast(context, 'Tentang (dummy)'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ===== Logout button =====
                _GlassCard(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _toast(context, 'Logout (dummy)'),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0x22EF4444)),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0x0FFF6B6B), Color(0x00FFFFFF)],
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 12.5,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ===== Background gradient (PURPLE) =====
class _GradientBackdropPurple extends StatelessWidget {
  const _GradientBackdropPurple();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDF4FF), // very light purple
            Color(0xFFF8FAFC),
            Color(0xFFF3E8FF), // lavender
          ],
        ),
      ),
      child: Stack(
        children: const [
          Positioned(top: -60, right: -40, child: _BlurBlob(size: 220, color: Color(0x556B257F))),
          Positioned(bottom: -80, left: -60, child: _BlurBlob(size: 260, color: Color(0x338B5CF6))),
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ===== Reusable UI =====
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  static const _border = Color(0x1A0F172A);
  static const _card = Color(0xCCFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: child,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleIcon({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

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
          border: Border.all(color: const Color(0x220F172A)),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor ?? const Color(0xFF0F172A)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 13,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DividerSoft extends StatelessWidget {
  const _DividerSoft();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, thickness: 1, color: Color(0x110F172A)),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  const _Pill({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.18)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.14), const Color(0x00FFFFFF)],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 11.5,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF1F5F9),
            border: Border.all(color: const Color(0x110F172A)),
          ),
          child: Icon(icon, color: accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 12.5,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11.5,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: accent,
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuRow({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF1F5F9),
                border: Border.all(color: const Color(0x110F172A)),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 12.5,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11.5,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
