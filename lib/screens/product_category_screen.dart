import 'package:flutter/material.dart';
import 'package:reloved/screens/product_detail_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class ProductCategoryScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryType;

  const ProductCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryType,
  });

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  String _sortBy = 'Terbaru';

  List<Map<String, String>> get _products {
    if (widget.categoryType == 'SECOND') {
      return [
        {'name': 'Sepatu Vans Second', 'price': 'Rp150.000', 'normalPrice': 'Rp300.000', 'loc': 'Malang', 'badge': 'SECOND'},
        {'name': 'Kaos Uniqlo', 'price': 'Rp50.000', 'normalPrice': 'Rp120.000', 'loc': 'Jember', 'badge': 'SECOND'},
        {'name': 'Tas Ransel Polo', 'price': 'Rp80.000', 'normalPrice': 'Rp200.000', 'loc': 'Surabaya', 'badge': 'SECOND'},
        {'name': 'Jaket Denim Levis', 'price': 'Rp180.000', 'normalPrice': 'Rp400.000', 'loc': 'Banyuwangi', 'badge': 'SECOND'},
      ];
    }
    if (widget.categoryType == 'REJECT') {
      return [
        {'name': 'Mouse Logitech Reject', 'price': 'Rp45.000', 'normalPrice': 'Rp90.000', 'loc': 'Surabaya', 'badge': 'REJECT'},
        {'name': 'Keyboard Mechanical Reject', 'price': 'Rp120.000', 'normalPrice': 'Rp250.000', 'loc': 'Malang', 'badge': 'REJECT'},
        {'name': 'Earphone Samsung Reject', 'price': 'Rp25.000', 'normalPrice': 'Rp60.000', 'loc': 'Jember', 'badge': 'REJECT'},
        {'name': 'Charger Original Reject', 'price': 'Rp35.000', 'normalPrice': 'Rp75.000', 'loc': 'Surabaya', 'badge': 'REJECT'},
      ];
    }
    return [
      {'name': 'Roti Sobek', 'price': 'Rp5.000', 'normalPrice': 'Rp12.000', 'loc': 'Jember', 'badge': 'EXPIRED', 'expiry': '3 hari lagi'},
      {'name': 'Susu UHT', 'price': 'Rp3.000', 'normalPrice': 'Rp8.000', 'loc': 'Banyuwangi', 'badge': 'EXPIRED', 'expiry': '1 hari lagi'},
      {'name': 'Yogurt Buah', 'price': 'Rp4.000', 'normalPrice': 'Rp10.000', 'loc': 'Malang', 'badge': 'EXPIRED', 'expiry': '2 hari lagi'},
      {'name': 'Snack Keripik', 'price': 'Rp2.000', 'normalPrice': 'Rp6.000', 'loc': 'Surabaya', 'badge': 'EXPIRED', 'expiry': '5 hari lagi'},
    ];
  }

  Color _badgeColor(String badge) => _primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryDark, _primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: _primary,
        title: Text(widget.categoryTitle,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text('${_products.length} produk',
                    style: const TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showSortSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(border: Border.all(color: _accent), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.sort, size: 14, color: _primary),
                        const SizedBox(width: 4),
                        Text(_sortBy, style: const TextStyle(fontSize: 12, color: _primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                if (widget.categoryType == 'EXPIRED') ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(border: Border.all(color: _accent), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list, size: 14, color: _primary),
                        SizedBox(width: 4),
                        Text('Filter Exp', style: TextStyle(fontSize: 12, color: _primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Grid 4 kolom, card persegi
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Hitung lebar tiap card: 4 kolom + padding + spacing
                const crossAxisCount = 4;
                const padding = 10.0;
                const spacing = 8.0;
                final cardWidth = (constraints.maxWidth - padding * 2 - spacing * (crossAxisCount - 1)) / crossAxisCount;
                // Gambar persegi = cardWidth, info di bawah ~80px
                final cardHeight = cardWidth + 82.0;
                final ratio = cardWidth / cardHeight;

                return GridView.builder(
                  padding: const EdgeInsets.all(padding),
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: ratio,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemBuilder: (context, i) {
                    final p = _products[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar — persegi sesuai lebar card
                            SizedBox(
                              width: cardWidth,
                              height: cardWidth, // persegi!
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: _accent.withOpacity(0.4),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.image_outlined, size: 22, color: _textSecondary),
                                    ),
                                  ),
                                  // Badge
                                  Positioned(
                                    top: 3, left: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _badgeColor(p['badge']!),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(p['badge']!,
                                          style: const TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.w800)),
                                    ),
                                  ),
                                  // Label expired
                                  if (p['expiry'] != null)
                                    Positioned(
                                      bottom: 3, left: 3, right: 3,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade600,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Text(p['expiry']!, textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  // Favorit
                                  Positioned(
                                    top: 3, right: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                                      child: const Icon(Icons.favorite_border, size: 9, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Info produk — fixed 80px
                            SizedBox(
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(p['name']!, maxLines: 2, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: _textPrimary, height: 1.2)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(p['normalPrice']!,
                                            style: const TextStyle(decoration: TextDecoration.lineThrough, color: _textSecondary, fontSize: 9)),
                                        Text(p['price']!,
                                            style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 11)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 8, color: _textSecondary),
                                        const SizedBox(width: 1),
                                        Expanded(
                                          child: Text(p['loc']!, overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 9, color: _textSecondary)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Urutkan',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
            const SizedBox(height: 12),
            for (final s in ['Terbaru', 'Harga Terendah', 'Harga Tertinggi'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(s,
                    style: TextStyle(
                        fontWeight: _sortBy == s ? FontWeight.w700 : FontWeight.normal,
                        color: _sortBy == s ? _primary : _textPrimary)),
                trailing: _sortBy == s ? const Icon(Icons.check, color: _primary) : null,
                onTap: () {
                  setState(() => _sortBy = s);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}