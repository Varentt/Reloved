import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class CheckoutScreen extends StatefulWidget {
  final Map<String, String> product;

  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddress = 0;
  int _selectedPayment = 0;

  final List<Map<String, String>> _addresses = [
    {
      'name': 'Rumah',
      'detail': 'Jl. Mawar No. 12, Jember, Jawa Timur 68111',
      'receiver': 'Nama Lengkap • 08123456789',
    },
    {
      'name': 'Kantor',
      'detail': 'Jl. Semeru No. 45, Malang, Jawa Timur 65112',
      'receiver': 'Nama Lengkap • 08123456789',
    },
  ];

  final List<Map<String, dynamic>> _payments = [
    {
      'name': 'Transfer Bank',
      'sub': 'BCA, BRI, BNI, Mandiri',
      'icon': Icons.account_balance_outlined,
    },
    {
      'name': 'Dompet Digital',
      'sub': 'GoPay, OVO, Dana, ShopeePay',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'name': 'Bayar di Tempat',
      'sub': 'COD - Cash On Delivery',
      'icon': Icons.payments_outlined,
    },
  ];

  String _formatPrice(String price) => price;

  int _parsePrice(String price) {
    return int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  String _toRupiah(int val) {
    final str = val.toString();
    final buf = StringBuffer('Rp');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final productPrice = _parsePrice(p['price'] ?? '0');
    final ongkir = 15000;
    final total = productPrice + ongkir;

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
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Ringkasan Produk ──
                  _SectionTitle(title: 'Ringkasan Produk'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
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
                                  decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(4)),
                                  child: Text(p['badge'] ?? 'SECOND',
                                      style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['name'] ?? 'Nama Produk',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                              const SizedBox(height: 4),
                              if (p['normalPrice'] != null)
                                Text(p['normalPrice']!,
                                    style: const TextStyle(decoration: TextDecoration.lineThrough, color: _textSecondary, fontSize: 12)),
                              Text(p['price'] ?? 'Rp0',
                                  style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 16)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.store_outlined, size: 11, color: _textSecondary),
                                  const SizedBox(width: 3),
                                  Text(p['loc'] ?? '-', style: const TextStyle(fontSize: 11, color: _textSecondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Alamat Pengiriman ──
                  _SectionTitle(title: 'Alamat Pengiriman'),
                  ...List.generate(_addresses.length, (i) {
                    final addr = _addresses[i];
                    final selected = _selectedAddress == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAddress = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? _primary : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: selected ? _primary.withOpacity(0.1) : _surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.location_on_outlined,
                                  color: selected ? _primary : _textSecondary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: selected ? _primary : _surface,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(addr['name']!,
                                            style: TextStyle(
                                                color: selected ? Colors.white : _textSecondary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(addr['receiver']!,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textPrimary)),
                                  const SizedBox(height: 2),
                                  Text(addr['detail']!,
                                      style: const TextStyle(fontSize: 12, color: _textSecondary, height: 1.4)),
                                ],
                              ),
                            ),
                            Radio<int>(
                              value: i,
                              groupValue: _selectedAddress,
                              onChanged: (val) => setState(() => _selectedAddress = val!),
                              activeColor: _primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _accent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: _primary, size: 18),
                          const SizedBox(width: 6),
                          const Text('Tambah Alamat Baru',
                              style: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Metode Pembayaran ──
                  _SectionTitle(title: 'Metode Pembayaran'),
                  ...List.generate(_payments.length, (i) {
                    final pay = _payments[i];
                    final selected = _selectedPayment == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPayment = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? _primary : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: selected ? _primary.withOpacity(0.1) : _surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(pay['icon'] as IconData,
                                  color: selected ? _primary : _textSecondary, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pay['name'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary)),
                                  Text(pay['sub'] as String,
                                      style: const TextStyle(fontSize: 11, color: _textSecondary)),
                                ],
                              ),
                            ),
                            Radio<int>(
                              value: i,
                              groupValue: _selectedPayment,
                              onChanged: (val) => setState(() => _selectedPayment = val!),
                              activeColor: _primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // ── Rincian Harga ──
                  _SectionTitle(title: 'Rincian Harga'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _PriceRow(label: 'Harga Produk', value: _formatPrice(p['price'] ?? 'Rp0')),
                        const SizedBox(height: 10),
                        _PriceRow(label: 'Ongkos Kirim', value: _toRupiah(ongkir)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: _surface),
                        ),
                        _PriceRow(
                          label: 'Total Pembayaran',
                          value: _toRupiah(total),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Tombol Beli ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran',
                        style: TextStyle(fontSize: 12, color: _textSecondary)),
                    Text(_toRupiah(total),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _primary)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showConfirmDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Konfirmasi Pesanan',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Pesanan', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Pastikan alamat dan metode pembayaran sudah benar ya!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cek Lagi', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pesanan berhasil dibuat!'),
                  backgroundColor: const Color(0xFF2e7d32),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Pesan Sekarang', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _textPrimary)),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.isTotal = false});
  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 14 : 13,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
                color: isTotal ? _textPrimary : _textSecondary)),
        Text(value,
            style: TextStyle(
                fontSize: isTotal ? 16 : 13,
                fontWeight: FontWeight.w800,
                color: isTotal ? _primary : _textPrimary)),
      ],
    );
  }
}