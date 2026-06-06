import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Sepatu Vans Second',
      'price': 150000,
      'badge': 'SECOND',
      'loc': 'Malang',
      'seller': 'Reloved Store',
      'qty': 1,
      'selected': true,
    },
    {
      'name': 'Mouse Logitech Reject',
      'price': 45000,
      'badge': 'REJECT',
      'loc': 'Surabaya',
      'seller': 'Gadget Murah',
      'qty': 1,
      'selected': true,
    },
    {
      'name': 'Roti Sobek',
      'price': 5000,
      'badge': 'EXPIRED',
      'loc': 'Jember',
      'seller': 'Mega Store',
      'qty': 2,
      'selected': false,
    },
  ];

  bool get _allSelected => _cartItems.every((i) => i['selected'] == true);

  int get _totalPrice => _cartItems
      .where((i) => i['selected'] == true)
      .fold(0, (sum, i) => sum + (i['price'] as int) * (i['qty'] as int));

  int get _selectedCount => _cartItems.where((i) => i['selected'] == true).length;

  void _toggleAll(bool? val) {
    setState(() {
      for (final item in _cartItems) {
        item['selected'] = val ?? false;
      }
    });
  }

  void _removeItem(int index) {
    setState(() => _cartItems.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item dihapus dari keranjang'),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  Color _badgeColor(String badge) {
    switch (badge) {
      case 'REJECT': return const Color(0xFFe65100);
      case 'EXPIRED': return const Color(0xFF2e7d32);
      default: return _primary;
    }
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
        title: Text(
          'Keranjang${_cartItems.isNotEmpty ? ' (${_cartItems.length})' : ''}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _cartItems.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                // Pilih semua
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _allSelected,
                        onChanged: _toggleAll,
                        activeColor: _primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      const Text('Pilih Semua',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                      const Spacer(),
                      if (_selectedCount > 0)
                        Text('$_selectedCount item dipilih',
                            style: const TextStyle(fontSize: 12, color: _textSecondary)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: _surface),

                // List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: _cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = _cartItems[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Checkbox
                            Checkbox(
                              value: item['selected'] as bool,
                              onChanged: (val) => setState(() => item['selected'] = val),
                              activeColor: _primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),

                            // Gambar
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  const Center(child: Icon(Icons.image_outlined, color: _textSecondary, size: 28)),
                                  Positioned(
                                    top: 4, left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _badgeColor(item['badge'] as String),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(item['badge'] as String,
                                          style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'] as String,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary)),
                                    const SizedBox(height: 2),
                                    Text(item['seller'] as String,
                                        style: const TextStyle(fontSize: 11, color: _textSecondary)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(_formatPrice(item['price'] as int),
                                            style: const TextStyle(
                                                color: _primary, fontWeight: FontWeight.w800, fontSize: 14)),
                                        const Spacer(),
                                        // Qty control
                                        _QtyButton(
                                          icon: Icons.remove,
                                          onTap: () {
                                            if ((item['qty'] as int) > 1) {
                                              setState(() => item['qty'] = (item['qty'] as int) - 1);
                                            } else {
                                              _removeItem(i);
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text('${item['qty']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add,
                                          onTap: () => setState(() => item['qty'] = (item['qty'] as int) + 1),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Bottom bar ──
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Total Pembayaran',
                              style: TextStyle(fontSize: 11, color: _textSecondary)),
                          Text(_formatPrice(_totalPrice),
                              style: const TextStyle(
                                  color: _primary, fontWeight: FontWeight.w900, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedCount > 0 ? () {} : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            disabledBackgroundColor: _accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _selectedCount > 0 ? 'Beli ($_selectedCount)' : 'Pilih Item',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: _accent),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: _primary),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
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
            child: const Icon(Icons.shopping_cart_outlined, size: 48, color: _primary),
          ),
          const SizedBox(height: 16),
          const Text('Keranjang masih kosong',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textPrimary)),
          const SizedBox(height: 6),
          const Text('Tambah produk yang kamu suka\nke keranjang dulu ya!',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}