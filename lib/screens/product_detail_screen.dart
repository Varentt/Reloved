import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class ProductDetailScreen extends StatefulWidget {
  final Map<String, String> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;

  Color get _badgeColor {
    switch (widget.product['badge']) {
      case 'REJECT':
        return const Color(0xFFe65100);
      case 'EXPIRED':
        return const Color(0xFF2e7d32);
      default:
        return _primary;
    }
  }

  String get _discountLabel {
    try {
      final price = int.parse(
          widget.product['price']!.replaceAll(RegExp(r'[^0-9]'), ''));
      final normal = int.parse(
          widget.product['normalPrice']!.replaceAll(RegExp(r'[^0-9]'), ''));
      final pct = ((normal - price) / normal * 100).round();
      return 'Hemat $pct%';
    } catch (_) {
      return 'Hemat';
    }
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
              // ── App Bar dengan gambar ──
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: _primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accent.withOpacity(0.6),
                          _accent.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.image_outlined,
                          size: 80, color: _textSecondary),
                    ),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: _textPrimary, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: _textPrimary, size: 18),
                        onPressed: () {},
                      ),
                    ),
                  ),
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
                        onPressed: () =>
                            setState(() => _isFavorite = !_isFavorite),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Konten ──
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
                        // Badge + diskon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _badgeColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(p['badge'] ?? 'SECOND',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Text(_discountLabel,
                                  style: const TextStyle(
                                      color: Color(0xFF2e7d32),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Text(p['name'] ?? 'Nama Produk',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: _textPrimary)),
                        const SizedBox(height: 8),
                        Text(p['normalPrice'] ?? '',
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: _textSecondary,
                                fontSize: 14)),
                        Text(p['price'] ?? 'Rp 0',
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: _primary)),

                        const SizedBox(height: 16),
                        const Divider(color: _surface),
                        const SizedBox(height: 12),

                        // Info kondisi
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _InfoRow('Kondisi', 'Sangat Baik'),
                              const SizedBox(height: 8),
                              _InfoRow('Kategori', _badgeLabel(p['badge'])),
                              const SizedBox(height: 8),
                              _InfoRow('Lokasi', p['loc'] ?? '-'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Penjual
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _accent),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: _accent,
                                child: const Icon(Icons.person,
                                    color: _primary, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Penjual',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: _textPrimary)),
                                    Text('Aktif 2 jam yang lalu',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: _textSecondary)),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: _primary),
                                  foregroundColor: _primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                ),
                                child: const Text('Lihat Toko',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: _surface),
                        const SizedBox(height: 12),

                        // Deskripsi
                        const Text('Deskripsi Produk',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _textPrimary)),
                        const SizedBox(height: 8),
                        const Text(
                          'Kondisi: Bekas (Sangat Baik)\n\n'
                          'Produk masih layak digunakan dan berada dalam kondisi baik. '
                          'Harga telah disesuaikan sehingga lebih hemat dibanding harga normal. '
                          'Cocok untuk pengguna yang ingin berbelanja lebih ekonomis dan ramah lingkungan. '
                          'Kelengkapan masih ada semua. Nego tipis-tipis boleh.',
                          style: TextStyle(
                              color: _textSecondary, height: 1.6, fontSize: 13),
                        ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Tombol bawah fixed (Chat dihapus, Beli Sekarang full width) ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Beli Sekarang',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _badgeLabel(String? badge) {
    switch (badge) {
      case 'REJECT':
        return 'Produk Reject';
      case 'EXPIRED':
        return 'Hampir Expired';
      default:
        return 'Barang Second';
    }
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
      children: [
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: _textPrimary)),
      ],
    );
  }
}