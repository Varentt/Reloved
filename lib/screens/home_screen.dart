import 'package:flutter/material.dart';
import 'package:reloved/screens/product_detail_screen.dart';
import 'package:reloved/screens/product_category_screen.dart';
import 'package:reloved/screens/notification_screen.dart';
import 'package:reloved/screens/cart_screen.dart';
import 'package:reloved/screens/my_products_screen.dart';
import 'package:reloved/screens/favorite_screen.dart'; // ← tambah import
import 'package:reloved/screens/add_product_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _products = [
    {
      'name': 'Sepatu Vans Second',
      'price': 'Rp150.000',
      'normalPrice': 'Rp300.000',
      'loc': 'Malang',
      'badge': 'SECOND',
    },
    {
      'name': 'Mouse Logitech Reject',
      'price': 'Rp45.000',
      'normalPrice': 'Rp90.000',
      'loc': 'Surabaya',
      'badge': 'REJECT',
    },
    {
      'name': 'Roti Sobek',
      'price': 'Rp5.000',
      'normalPrice': 'Rp12.000',
      'loc': 'Jember',
      'badge': 'EXPIRED',
    },
    {
      'name': 'Kaos Uniqlo',
      'price': 'Rp50.000',
      'normalPrice': 'Rp120.000',
      'loc': 'Banyuwangi',
      'badge': 'SECOND',
    },
    {
      'name': 'Keyboard Mechanical',
      'price': 'Rp120.000',
      'normalPrice': 'Rp250.000',
      'loc': 'Malang',
      'badge': 'REJECT',
    },
    {
      'name': 'Susu UHT',
      'price': 'Rp3.000',
      'normalPrice': 'Rp8.000',
      'loc': 'Banyuwangi',
      'badge': 'EXPIRED',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryDark, _primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Reloved',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      // ── PERUBAHAN 1: tambah ikon favorit di sini ──
                      _topIconBtn(Icons.favorite_border, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoriteScreen(),
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      _topIconBtn(Icons.notifications_none_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      _topIconBtn(Icons.shopping_cart_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari barang second, reject, expired...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: _textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: _textSecondary,
                        size: 20,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──
            Expanded(
              child: RefreshIndicator(
                color: _primary,
                onRefresh: () async {},
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner
                      const _BannerSlider(),
                      const SizedBox(height: 4),

                      // Kategori
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: Text(
                          'Kategori Utama',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _CategoryCard(
                                icon: Icons.recycling,
                                label: 'Barang\nSecond',
                                color: _primary,
                                onTap: () => _goCategory(
                                  context,
                                  'Barang Second',
                                  'SECOND',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _CategoryCard(
                                icon: Icons.inventory_2_outlined,
                                label: 'Produk\nReject',
                                color: _primary,
                                onTap: () => _goCategory(
                                  context,
                                  'Produk Reject',
                                  'REJECT',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _CategoryCard(
                                icon: Icons.fastfood_outlined,
                                label: 'Hampir\nExpired',
                                color: _primary,
                                onTap: () => _goCategory(
                                  context,
                                  'Makanan Hampir Expired',
                                  'EXPIRED',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Produk Terkini
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                        child: Text(
                          'Produk Terkini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                          ),
                        ),
                      ),

                      // Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                          const padding = 16.0;
                          const spacing = 8.0;
                          final cardWidth =
                              (constraints.maxWidth -
                                  padding * 2 -
                                  spacing * (crossAxisCount - 1)) /
                              crossAxisCount;
                          // Sesuaikan tinggi agar konten tidak overflow bawah
                          final cardHeight = cardWidth + 80.0;
                          final ratio = cardWidth / cardHeight;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: padding,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: ratio,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                  ),
                              itemCount: _products.length,
                              itemBuilder: (context, i) => _ProductCard(
                                product: _products[i],
                                cardWidth: cardWidth,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      product: _products[i],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goCategory(BuildContext context, String title, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductCategoryScreen(categoryTitle: title, categoryType: type),
      ),
    );
  }

  Widget _topIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ── Banner Slider ──
class _BannerSlider extends StatefulWidget {
  const _BannerSlider();

  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  int _page = 0;
  final _ctrl = PageController();

  final _banners = [
    {
      'title': 'Temukan Barang\nPreloved Berkualitas',
      'sub': 'Hemat lebih banyak, ramah lingkungan',
      'icon': Icons.recycling,
      'colors': [Color(0xFF2e4a73), Color(0xFF3B5B8A)],
    },
    {
      'title': 'Produk Reject\nHarga Terjangkau',
      'sub': 'Kualitas oke, harga lebih hemat',
      'icon': Icons.inventory_2_outlined,
      'colors': [Color(0xFF2e4a73), Color(0xFF3B5B8A)],
    },
    {
      'title': 'Makanan Hampir\nExpired Murah!',
      'sub': 'Jangan buang makanan, hemat bersama',
      'icon': Icons.fastfood_outlined,
      'colors': [Color(0xFF2e4a73), Color(0xFF3B5B8A)],
    },
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _ctrl,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) {
              final b = _banners[i];
              final colors = b['colors'] as List<Color>;
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors[1].withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            b['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b['sub'] as String,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddProductScreen(),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B8AB1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Text(
                                'Jual Sekarang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      b['icon'] as IconData,
                      size: 56,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
              width: _page == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _page == i ? _primary : _accent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Category Card ──
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product Card ──
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.cardWidth,
    required this.onTap,
  });
  final Map<String, String> product;
  final double cardWidth;
  final VoidCallback onTap;

  Color get _badgeColor => _primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: cardWidth,
              height: cardWidth,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.4),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 22,
                        color: _textSecondary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3,
                    left: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _badgeColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        product['badge']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  // ── PERUBAHAN 2: ikon hati non-interaktif (IgnorePointer) ──
                  Positioned(
                    top: 3,
                    right: 3,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 9,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      color: _textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product['normalPrice']!,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: _textSecondary,
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    product['price']!,
                    style: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 7,
                        color: _textSecondary,
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: Text(
                          product['loc']!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 8,
                            color: _textSecondary,
                          ),
                        ),
                      ),
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
