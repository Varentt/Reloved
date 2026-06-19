import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/product_service.dart';
import 'package:reloved/services/favorite_service.dart';
import 'package:reloved/screens/product_detail_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _productService = ProductService();
  final _favoriteService = FavoriteService();

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        title: const Text('Favorit Saya',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryDark, _primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: user == null
          ? const Center(child: Text('Silakan login terlebih dahulu'))
          : StreamBuilder<List<String>>(
              stream: _favoriteService.getUserFavoriteProductIds(user.uid),
              builder: (context, favSnap) {
                if (favSnap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _primary));
                final favIds = favSnap.data ?? [];

                return StreamBuilder<List<ProductModel>>(
                  stream: _productService.activeProductsStream,
                  builder: (context, prodSnap) {
                    if (prodSnap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: _primary));
                    final allProducts = prodSnap.data ?? [];
                    final favorites = allProducts.where((p) => favIds.contains(p.id)).toList();

                    if (favorites.isEmpty) {
                      return _EmptyState();
                    }

                    return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: Text(
                  '${favorites.length} produk tersimpan',
                  style: const TextStyle(fontSize: 13, color: _textSecondary, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = favorites[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: p),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.4),
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: p.imageUrl.isNotEmpty
                                        ? Image.network(p.imageUrl, fit: BoxFit.cover)
                                        : const Icon(Icons.image_outlined, color: _textSecondary, size: 30),
                                  ),
                                  Positioned(
                                    top: 6, left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(5)),
                                      child: Text(p.category.split(' ').last.toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary)),
                                    const SizedBox(height: 4),
                                    if (p.normalPrice > 0)
                                      Text(_formatRupiah(p.normalPrice),
                                          style: const TextStyle(decoration: TextDecoration.lineThrough, color: _textSecondary, fontSize: 11)),
                                    Text(_formatRupiah(p.price),
                                        style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 11, color: _textSecondary),
                                        const SizedBox(width: 2),
                                        Text(p.location, style: const TextStyle(fontSize: 10, color: _textSecondary)),
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
                ),
              ),
            ],
          );
        },
      );
    },
  ),
);
  }
}


class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, size: 48, color: _primary),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada produk favorit',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: _textPrimary)),
          const SizedBox(height: 6),
          const Text('Simpan produk yang kamu suka\nuntuk dilihat nanti',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}