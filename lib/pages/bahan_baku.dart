// lib/pages/bahan_baku.dart
import 'package:flutter/material.dart';
import 'package:fashion_mobile/services/api_service.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'marketplace.dart';
import 'wishlist.dart';
import 'chat.dart';
import 'checkout.dart';
import 'pembelian.dart';
import 'pengiriman.dart';

// Brand Color tetap sama
const Color kPurple = Color(0xFF6B257F);

class BahanBakuScreen extends StatefulWidget {
  const BahanBakuScreen({super.key});

  @override
  State<BahanBakuScreen> createState() => _BahanBakuScreenState();
}

class _BahanBakuScreenState extends State<BahanBakuScreen> {
  int _activeCategory = 0;

  static const _categories = [
    'Semua',
    'Kain',
    'Benang',
    'Aksesoris',
    'Packaging',
    'Lainnya',
  ];

  String get _category => _categories[_activeCategory];
  late Future<List<dynamic>> _materialsFuture;

  @override
  void initState() {
    super.initState();
    _materialsFuture = ApiService().getMaterials();
  }

  Future<void> _refreshData() async {
    setState(() {
      _materialsFuture = ApiService().getMaterials();
    });
  }

  // --- DIALOGS (Logika tidak berubah, hanya UI standard) ---
  void _showEditDialog(dynamic item) {
    final idController = TextEditingController(text: item['id'].toString());
    final nameController = TextEditingController(text: item['material_name']);
    final stockController = TextEditingController(text: item['stock_quantity'].toString());
    final priceController = TextEditingController(text: item['price_per_unit'].toString());
    final imageController = TextEditingController(text: item['image_url'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Bahan Baku"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama Barang")),
                TextField(controller: stockController, decoration: const InputDecoration(labelText: "Stok"), keyboardType: TextInputType.number),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: "Harga per Unit"), keyboardType: TextInputType.number),
                TextField(controller: imageController, decoration: const InputDecoration(labelText: "Link Gambar (URL)")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPurple),
              onPressed: () async {
                try {
                  await ApiService().updateMaterial(
                    idController.text,
                    nameController.text,
                    stockController.text,
                    priceController.text,
                    imageController.text,
                  );
                  Navigator.pop(context);
                  _refreshData();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil diupdate!")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showRestockDialog(dynamic item) {
    final qtyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Restock ${item['material_name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Masukkan jumlah stok yang baru datang:"),
              const SizedBox(height: 10),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Jumlah (Pcs/Meter)",
                  border: OutlineInputBorder(),
                  hintText: "Contoh: 10",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPurple),
              onPressed: () async {
                if (qtyController.text.isEmpty) return;
                try {
                  await ApiService().restockMaterial(
                    item['id'].toString(),
                    qtyController.text,
                  );
                  Navigator.pop(context);
                  _refreshData();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stok berhasil ditambah!")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("Tambah", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final nameC = TextEditingController();
    final stockC = TextEditingController();
    final unitC = TextEditingController();
    final priceC = TextEditingController();
    final imageC = TextEditingController();
    String selectedCategory = _categories.length > 1 ? _categories[1] : 'Lainnya'; 

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Tambah Barang Baru"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama Barang")),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: stockC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Stok Awal"))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: unitC, decoration: const InputDecoration(labelText: "Satuan (Pcs/Meter)"))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: priceC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Harga per Unit")),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: "Kategori"),
                      items: _categories.where((c) => c != 'Semua').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: imageC, decoration: const InputDecoration(labelText: "Link Gambar (URL)")),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kPurple),
                  onPressed: () async {
                    if (nameC.text.isEmpty || stockC.text.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama dan Stok wajib diisi!")));
                       return;
                    }
                    try {
                      await ApiService().addMaterial(nameC.text, stockC.text, unitC.text, priceC.text, selectedCategory, imageC.text);
                      Navigator.pop(context);
                      _refreshData();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Barang baru berhasil ditambahkan!")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // 1. CEK DARK MODE
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // 2. TENTUKAN WARNA BACKGROUND DINAMIS
    final Color bgColor = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F7FB);

    return Scaffold(
      backgroundColor: bgColor, // <--- Pakai variabel dinamis
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: kPurple,
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _QuickMenuGrid(),
                      const SizedBox(height: 18),

                      _CategoryRow(
                        active: _activeCategory,
                        categories: _categories,
                        onChanged: (idx) => setState(() => _activeCategory = idx),
                      ),

                      const SizedBox(height: 18),

                      FutureBuilder<List<dynamic>>(
                        future: _materialsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: kPurple)));
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: isDark ? Colors.white : Colors.black)));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("Belum ada data bahan baku.", style: TextStyle(color: isDark ? Colors.white : Colors.black)));
                          }

                          final allMaterials = snapshot.data!;
                          final filteredMaterials = _activeCategory == 0 
                              ? allMaterials 
                              : allMaterials.where((item) {
                                  final dbCategory = (item['category'] ?? '').toString().toLowerCase().trim();
                                  final tabCategory = _category.toLowerCase().trim();
                                  return dbCategory == tabCategory;
                                }).toList();

                          if (filteredMaterials.isEmpty) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  "Tidak ada item di kategori $_category",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          }

                          return _MaterialGrid(
                            materials: filteredMaterials,
                            onEdit: _showEditDialog,
                            onAdd: _showRestockDialog
                          );
                        },
                      ),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== GRID TAMPILAN MATERIAL ==================
class _MaterialGrid extends StatelessWidget {
  final List<dynamic> materials;
  final Function(dynamic) onEdit;
  final Function(dynamic) onAdd;

  const _MaterialGrid({
    super.key,
    required this.materials,
    required this.onEdit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Cek Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF24252C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Stok Gudang (${materials.length})',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Encode Sans',
                fontWeight: FontWeight.w900,
                color: titleColor, // <--- Warna Teks Dinamis
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: materials.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final item = materials[index];
            return _ProductCard(
              item: item,
              onEditTap: () => onEdit(item),
              onAddTap: () => onAdd(item),
            );
          },
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onEditTap;
  final VoidCallback onAddTap;

  const _ProductCard({
    required this.item, 
    required this.onEditTap,
    required this.onAddTap,
  });

  String _formatCurrency(dynamic price) {
    if (price == null) return 'Rp 0';
    double priceDouble = double.tryParse(price.toString()) ?? 0.0;
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(priceDouble);
  }

  @override
  Widget build(BuildContext context) {
    final name = item['material_name'] ?? 'Tanpa Nama';
    final stock = item['stock_quantity'] ?? '0';
    final unit = item['unit'] ?? '';
    final price = item['price_per_unit'] ?? '0';
    final String? dbImage = item['image_url'];
    final bool hasNetImage = dbImage != null && dbImage.isNotEmpty;

    // === LOGIKA WARNA DINAMIS ===
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xFF1F2937) : Colors.white; // Putih vs Abu Gelap
    final Color textColor = isDark ? Colors.white : const Color(0xFF121111);
    final Color priceColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF24252C);
    final Color borderColor = isDark ? Colors.white12 : const Color(0x0FE8ECF4);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: cardBg, // <--- Ubah Background Card
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8)),
          ],
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: hasNetImage
                          ? Image.network(
                              dbImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey)));
                              },
                            )
                          : Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.image_not_supported_rounded, color: Colors.grey))),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: onEditTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92), // Tombol Edit tetap putih transparan biar kontras sama gambar
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_outlined, size: 18, color: kPurple),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Encode Sans',
                      fontWeight: FontWeight.w900,
                      color: textColor, // <--- Warna Nama Dinamis
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Stok: $stock $unit",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B7280), // Stok tetap abu-abu oke
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatCurrency(price),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w900,
                            color: priceColor, // <--- Warna Harga Dinamis
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onAddTap,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E4FF), // Tombol plus tetap ungu muda
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.add_rounded, color: kPurple, size: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== HEADER ==================
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: kPurple, // Header tetap ungu Brand
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIcon(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bahan Baku',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Encode Sans',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _HeaderIcon(
                icon: Icons.home_filled,
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
          const SizedBox(height: 12),
          _SearchBar(onTap: () {}),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const _SearchBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.white70, size: 20),
            SizedBox(width: 10),
            Text(
              'Cari bahan baku, kain, aksesoris...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== QUICK MENU ==================
class _QuickMenuGrid extends StatelessWidget {
  const _QuickMenuGrid();

  @override
  Widget build(BuildContext context) {
    // Cek Dark Mode untuk Judul
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF24252C);

    final items = <_QuickItem>[
      const _QuickItem('Marketplace', Icons.storefront_outlined),
      const _QuickItem('Wishlist', Icons.favorite_border),
      const _QuickItem('Keranjang', Icons.shopping_cart_outlined),
      const _QuickItem('Chat', Icons.chat_bubble_outline),
      const _QuickItem('Pembelian', Icons.local_offer_outlined),
      const _QuickItem('Pengiriman', Icons.local_shipping_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: TextStyle(
            color: titleColor, // <--- Dinamis
            fontSize: 16,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, i) {
            final it = items[i];
            return _QuickCardSmall(
              label: it.label,
              icon: it.icon,
              onTap: () => _goQuick(context, it.label),
            );
          },
        ),
      ],
    );
  }

  void _goQuick(BuildContext context, String label) {
    if (label == 'Marketplace') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()));
      return;
    }
    if (label == 'Wishlist') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
      return;
    }
    if (label == 'Keranjang') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
      return;
    }
    if (label == 'Chat') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      return;
    }
    if (label == 'Pembelian') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PembelianScreen()));
      return;
    }
    if (label == 'Pengiriman') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PengirimanScreen()));
      return;
    }
  }
}

class _QuickItem {
  final String label;
  final IconData icon;
  const _QuickItem(this.label, this.icon);
}

class _QuickCardSmall extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickCardSmall({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // === LOGIKA WARNA QUICK MENU ===
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xFF1F2937) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF24252C);
    final Color borderColor = isDark ? Colors.white12 : const Color(0x0FE8ECF4);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg, // <--- Dinamis
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            )
          ],
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E4FF), // Tetap ungu muda biar konsisten sama brand
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: kPurple, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor, // <--- Dinamis
                fontSize: 11.5,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== CATEGORY ROW ==================
class _CategoryRow extends StatelessWidget {
  final int active;
  final List<String> categories;
  final ValueChanged<int> onChanged;

  const _CategoryRow({
    required this.active,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF24252C);
    final Color inactiveBg = isDark ? const Color(0xFF1F2937) : Colors.white; // Tombol tidak aktif jadi gelap
    final Color inactiveBorder = isDark ? Colors.white12 : const Color(0xFFE8ECF4);
    final Color inactiveText = isDark ? Colors.grey : const Color(0xFF6B7280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: TextStyle(
            color: titleColor, // <--- Dinamis
            fontSize: 16,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isActive = index == active;
              return InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? kPurple : inactiveBg, // <--- Dinamis
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isActive ? kPurple : inactiveBorder,
                    ),
                    boxShadow: isActive
                        ? const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      )
                    ]
                        : null,
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: isActive ? Colors.white : inactiveText,
                      fontSize: 12,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}