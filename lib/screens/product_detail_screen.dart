import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/models/user_model.dart';
import 'package:reloved/services/auth_service.dart';
import 'package:reloved/screens/checkout_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  int _qty = 1;

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price);
  }

  Color get _badgeColor {
    final cat = widget.product.category.toLowerCase();
    if (cat.contains('second')) return Colors.blue;
    if (cat.contains('reject')) return Colors.orange;
    if (cat.contains('expired')) return Colors.red;
    return _primary;
  }

  String get _discountLabel {
    if (widget.product.normalPrice <= widget.product.price) return 'Hemat';
    final pct = ((widget.product.normalPrice - widget.product.price) / widget.product.normalPrice * 100).round();
    return 'Hemat $pct%';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: _surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: _primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(color: _accent.withOpacity(0.3)),
                    child: p.imageUrl.isNotEmpty
                        ? Image.network(p.imageUrl, fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.image_outlined, size: 80, color: _textSecondary)),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: _textPrimary, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : _textPrimary,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _isFavorite = !_isFavorite),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: _badgeColor, borderRadius: BorderRadius.circular(7)),
                              child: Text(p.category.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Text(_discountLabel,
                                  style: const TextStyle(color: Color(0xFF2e7d32), fontWeight: FontWeight.w700, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(p.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textPrimary)),
                        const SizedBox(height: 8),
                        if (p.normalPrice > 0)
                          Text(_formatRupiah(p.normalPrice),
                              style: const TextStyle(decoration: TextDecoration.lineThrough, color: _textSecondary, fontSize: 14)),
                        Text(_formatRupiah(p.price),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _primary)),
                        const SizedBox(height: 16),
                        const Divider(color: _surface),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: _surface, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              _InfoRow('Kondisi', p.condition),
                              const SizedBox(height: 8),
                              _InfoRow('Lokasi', p.location),
                              const SizedBox(height: 8),
                              _InfoRow('Diterbitkan', '${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // ── Info Penjual ──
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _accent),
                          ),
                          child: FutureBuilder<UserModel?>(
                            future: AuthService().getUserData(p.ownerId),
                            builder: (context, snapshot) {
                              final seller = snapshot.data;
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: _accent,
                                    child: const Icon(Icons.person, color: _primary, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(seller?.name ?? 'Memuat Penjual...',
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                                        const Text('Penjual Terverifikasi',
                                            style: TextStyle(fontSize: 12, color: _textSecondary)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: _surface),
                        const SizedBox(height: 12),
                        const Text('Deskripsi Produk',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textPrimary)),
                        const SizedBox(height: 8),
                        Text(
                          p.description.isNotEmpty ? p.description : 'Tidak ada deskripsi untuk produk ini.',
                          style: const TextStyle(color: _textSecondary, height: 1.6, fontSize: 13),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Keranjang segera hadir')));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Keranjang', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primary,
                        side: const BorderSide(color: _primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CheckoutScreen.fromProductModel(p, qty: _qty)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Beli Sekarang', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 13)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary),
          ),
        ),
      ],
    );
  }
}
