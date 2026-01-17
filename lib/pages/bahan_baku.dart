// lib/pages/bahan_baku.dart
import 'package:flutter/material.dart';
import 'home.dart';
import 'marketplace.dart';
import 'wishlist.dart';
import 'chat.dart';
import 'checkout.dart';
import 'pembelian.dart';
import 'pengiriman.dart';

const Color kPurple = Color(0xFF6B257F);
const Color kSoftGrey = Color(0xFFF6F4F0);

class BahanBakuScreen extends StatelessWidget {
  const BahanBakuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _BahanBakuHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _MenuTopGrid(),
                    SizedBox(height: 24),
                    _RekomendasiSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================== HEADER ==================
//
class _BahanBakuHeader extends StatelessWidget {
  const _BahanBakuHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol back
          InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFDFDEDE)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),

          const Text(
            'Bahan Baku',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              color: Color(0xFF121111),
            ),
          ),

          // Tombol Home
          InkWell(
            borderRadius: BorderRadius.circular(32),
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
                border: Border.all(color: const Color(0xFFDFDEDE)),
              ),
              child: const Icon(
                Icons.home_outlined,
                size: 20,
                color: kPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ================== MENU ATAS (Marketplace, Wishlist, dll) ==================
//
class _MenuTopGrid extends StatelessWidget {
  const _MenuTopGrid();

  @override
  Widget build(BuildContext context) {
    final items = <_MenuTopItemData>[
      const _MenuTopItemData('Marketplace', Icons.storefront_outlined),
      const _MenuTopItemData('Wishlist', Icons.favorite_border),
      const _MenuTopItemData('Keranjang', Icons.shopping_cart_outlined),
      const _MenuTopItemData('Chat', Icons.chat_bubble_outline),
      const _MenuTopItemData('Pembelian', Icons.local_offer_outlined),
      const _MenuTopItemData('Pengiriman', Icons.local_shipping_outlined),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (e) => _MenuTopItem(
          label: e.label,
          icon: e.icon,
        ),
      )
          .toList(),
    );
  }
}

class _MenuTopItemData {
  final String label;
  final IconData icon;
  const _MenuTopItemData(this.label, this.icon);
}

class _MenuTopItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MenuTopItem({
    super.key,
    required this.label,
    required this.icon,
  });

  void _handleTap(BuildContext context) {
    if (label == 'Marketplace') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
      );
      return;
    }
    if (label == 'Wishlist') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WishlistScreen()),
      );
      return;
    }

    if (label == 'Chat') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      );
      return;
    }

    if (label == 'Keranjang') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
      );
      return;
    }

    if (label == 'Pembelian') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PembelianScreen()),
      );
      return;
    }

    if (label == 'Pengiriman') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PengirimanScreen()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 24 * 2 - 12 * 2) / 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _handleTap(context), // ✅ klik menu
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kPurple, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF393333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// ================== REKOMENDASI ==================
//
class _RekomendasiSection extends StatelessWidget {
  const _RekomendasiSection();

  @override
  Widget build(BuildContext context) {
    final products = <_Product>[
      const _Product(
        title: 'Modern Light Clothes',
        subtitle: 'T-Shirt',
        price: '\$212.99',
        rating: '5.0',
        image: 'assets/images/adidas.jpg',
      ),
      const _Product(
        title: 'Light Dress Bless',
        subtitle: 'Dress modern',
        price: '\$162.99',
        rating: '5.0',
        image: 'assets/images/nike.jpg',
      ),
      const _Product(
        title: 'Urban Street Style',
        subtitle: 'Jacket',
        price: '\$189.99',
        rating: '4.9',
        image: 'assets/images/nike.jpg',
      ),
      const _Product(
        title: 'Soft Grey Hoodie',
        subtitle: 'Sweater',
        price: '\$129.99',
        rating: '4.8',
        image: 'assets/images/adidas.jpg',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi',
          style: TextStyle(
            fontSize: 19,
            fontFamily: 'Lexend Deca',
            fontWeight: FontWeight.w600,
            color: Color(0xFF24252C),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.55,
          ),
          itemBuilder: (context, index) {
            final p = products[index];
            return _ProductCard(product: p);
          },
        ),
      ],
    );
  }
}

class _Product {
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final String image;

  const _Product({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.image,
  });
}

class _ProductCard extends StatelessWidget {
  final _Product product;

  const _ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // gambar
        Container(
          height: 210,
          decoration: BoxDecoration(
            color: kSoftGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w600,
            color: Color(0xFF121111),
          ),
        ),
        Text(
          product.subtitle,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w400,
            color: Color(0xFF787676),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Encode Sans',
                fontWeight: FontWeight.w600,
                color: Color(0xFF292526),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              product.rating,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Encode Sans',
                fontWeight: FontWeight.w400,
                color: Color(0xFF292526),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
