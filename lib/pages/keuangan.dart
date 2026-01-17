// keuangan.dart
import 'package:fashion_mobile/pages/operasional.dart';
import 'package:fashion_mobile/pages/pemasukan.dart';
import 'package:fashion_mobile/pages/rencana_belanja.dart';
import 'package:fashion_mobile/pages/rugi_laba.dart';
import 'package:fashion_mobile/pages/upah.dart';
import 'package:flutter/material.dart';
import 'pengeluaran.dart';
import 'promosi.dart';
import 'home.dart';

// ✅ sesuaikan path sesuai struktur kamu
import 'keuanganproyek.dart';

class KeuanganScreen extends StatelessWidget {
  const KeuanganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6B257F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ========= HEADER UNGU =========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // --- top bar back + title + home ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back
                      InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFFDFDEDE),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        'Keuangan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Encode Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      // home button
                      InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                                (route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFFDFDEDE),
                            ),
                          ),
                          child: const Icon(
                            Icons.home_filled,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- summary: total balance & expense ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // left
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$7,783.00',
                            style: TextStyle(
                              color: Color(0xFFF1FFF3),
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 42,
                        width: 1,
                        color: const Color(0xFFDFF7E2),
                      ),
                      // right
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total Expense',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '-\$1,187.40',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- progress bar 30% ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 27,
                        child: Stack(
                          children: [
                            // background dark
                            Container(
                              height: 27,
                              decoration: BoxDecoration(
                                color: const Color(0xFF052224),
                                borderRadius: BorderRadius.circular(13.5),
                              ),
                            ),
                            // hijau progress (75%)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth * 0.75;
                                return Positioned(
                                  left: constraints.maxWidth * 0.22,
                                  child: Container(
                                    height: 27,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1FFF3),
                                      borderRadius: BorderRadius.circular(13.5),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // text 30%
                            const Positioned(
                              left: 12,
                              top: 5,
                              child: Text(
                                '30%',
                                style: TextStyle(
                                  color: Color(0xFFF1FFF3),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            // text 20.000
                            const Positioned(
                              right: 12,
                              top: 5,
                              child: Text(
                                '\$20,000.00',
                                style: TextStyle(
                                  color: Color(0xFF052224),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '30% Of Your Expenses, Looks Good.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ========= BODY PUTIH (SCROLLABLE) =========
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: const _MenuGridKeuangan(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== MODEL MENU =====
class _FinanceMenu {
  final String label;
  final IconData icon;

  const _FinanceMenu({
    required this.label,
    required this.icon,
  });
}

// ===== GRID MENU (8 ITEM) =====
class _MenuGridKeuangan extends StatelessWidget {
  final List<_FinanceMenu> menus = const [
    _FinanceMenu(label: 'Keuangan', icon: Icons.savings),
    _FinanceMenu(label: 'Operasional', icon: Icons.local_shipping),
    _FinanceMenu(label: 'Pemasukan', icon: Icons.attach_money),
    _FinanceMenu(label: 'Pengeluaran', icon: Icons.outbond),
    _FinanceMenu(label: 'Promosi', icon: Icons.percent),
    _FinanceMenu(label: 'Rencana Belanja', icon: Icons.shopping_bag_outlined),
    _FinanceMenu(label: 'Rugi Laba', icon: Icons.heart_broken),
    _FinanceMenu(label: 'Upah', icon: Icons.work_outline),
  ];

  const _MenuGridKeuangan({super.key});

  void _handleTap(BuildContext context, String label) {
    if (label == 'Keuangan') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KeuanganProyekScreen()),
      );
      return;
    }
    if (label == 'Operasional') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OperasionalScreen()),
      );
      return;
    }

    if (label == 'Pemasukan') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PemasukanScreen()),
      );
      return;
    }
    if (label == 'Pengeluaran') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PengeluaranScreen()),
      );
      return;
    }
    if (label == 'Promosi') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PromosiScreen()),
      );
      return;
    }
    if (label == 'Rencana Belanja') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RencanaBelanjaScreen()),
      );
      return;
    }
    if (label == 'Rugi Laba') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RugiLabaScreen()),
      );
      return;
    }
    if (label == 'Upah') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UpahScreen()),
      );
      return;
    }

    // sementara untuk menu lain
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label (belum dibuat)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        // dibuat lebih tinggi agar tidak overflow
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final item = menus[index];
        return _MenuItemKeuangan(
          item: item,
          onTap: () => _handleTap(context, item.label),
        );
      },
    );
  }
}

class _MenuItemKeuangan extends StatelessWidget {
  final _FinanceMenu item;
  final VoidCallback onTap;

  const _MenuItemKeuangan({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                item.icon,
                size: 28,
                color: const Color(0xFF6B257F),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF8F8F8F),
              fontSize: 11,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
