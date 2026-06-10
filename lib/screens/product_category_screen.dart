import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/services/product_service.dart';
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
  String _expFilter = 'Semua';
  final _productService = ProductService();

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price);
  }

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
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Text('Katalog Produk',
                    style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
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
                  GestureDetector(
                    onTap: () => _showExpFilterSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: _expFilter != 'Semua' ? _primary : _accent),
                        borderRadius: BorderRadius.circular(8),
                        color: _expFilter != 'Semua' ? _primary.withOpacity(0.08) : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list, size: 14, color: _primary),
                          const SizedBox(width: 4),
                          Text(
                            _expFilter == 'Semua' ? 'Filter Exp' : 'Exp: $_expFilter',
                            style: const TextStyle(fontSize: 12, color: _primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Grid (Real-time dari Firestore)
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _productService.activeProductsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                // Filter berdasarkan kategori
                var products = snapshot.data?.where((p) => p.category == widget.categoryTitle).toList() ?? [];

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 60, color: _accent),
                        const SizedBox(height: 12),
                        Text('Tidak ada produk di kategori ini', style: TextStyle(color: _textSecondary)),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                    const padding = 10.0;
                    const spacing = 8.0;
                    final cardWidth = (constraints.maxWidth - padding * 2 - spacing * (crossAxisCount - 1)) / crossAxisCount;
                    final cardHeight = cardWidth + 82.0;
                    final ratio = cardWidth / cardHeight;

                    return GridView.builder(
                      padding: const EdgeInsets.all(padding),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: ratio,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemBuilder: (context, i) {
                        final p = products[i];
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
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        ),
                                        child: p.imageUrl.isNotEmpty
                                            ? Image.network(p.imageUrl, fit: BoxFit.cover)
                                            : const Center(child: Icon(Icons.image_outlined, size: 22, color: _textSecondary)),
                                      ),
                                      Positioned(
                                        top: 3, left: 3,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _primary,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text(p.category.split(' ').last.toUpperCase(),
                                              style: const TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.w800)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: _textPrimary, height: 1.2)),
                                      const SizedBox(height: 2),
                                      if (p.normalPrice > 0)
                                        Text(_formatRupiah(p.normalPrice),
                                            style: const TextStyle(decoration: TextDecoration.lineThrough, color: _textSecondary, fontSize: 9)),
                                      Text(_formatRupiah(p.price),
                                          style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  void _showExpFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Kadaluarsa',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
            const SizedBox(height: 4),
            const Text('Urutkan berdasarkan tanggal kadaluarsa',
                style: TextStyle(fontSize: 12, color: _textSecondary)),
            const SizedBox(height: 12),
            for (final option in [
              {'value': 'Semua', 'label': 'Semua', 'desc': 'Tampilkan semua produk', 'icon': Icons.all_inclusive},
              {'value': 'Terdekat', 'label': 'Exp Terdekat', 'desc': 'Produk yang akan segera kadaluarsa', 'icon': Icons.alarm},
              {'value': 'Terjauh', 'label': 'Exp Terjauh', 'desc': 'Produk dengan masa berlaku paling lama', 'icon': Icons.event_available},
            ])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _expFilter == option['value'] ? _primary.withOpacity(0.12) : _accent.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(option['icon'] as IconData,
                      size: 18,
                      color: _expFilter == option['value'] ? _primary : _textSecondary),
                ),
                title: Text(option['label'] as String,
                    style: TextStyle(
                        fontWeight: _expFilter == option['value'] ? FontWeight.w700 : FontWeight.w500,
                        color: _expFilter == option['value'] ? _primary : _textPrimary,
                        fontSize: 14)),
                subtitle: Text(option['desc'] as String,
                    style: const TextStyle(fontSize: 11, color: _textSecondary)),
                trailing: _expFilter == option['value']
                    ? const Icon(Icons.check_circle, color: _primary)
                    : null,
                onTap: () {
                  setState(() => _expFilter = option['value'] as String);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
