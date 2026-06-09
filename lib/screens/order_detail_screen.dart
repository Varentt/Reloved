import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class OrderDetailScreen extends StatefulWidget {
  final Map<String, String> order;
  final String type; // 'pembelian' atau 'penjualan'

  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.type,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order['status']!;
  }

  final List<String> _statusFlowPembelian = [
    'Menunggu Konfirmasi',
    'Dikemas',
    'Dikirim',
    'Selesai',
  ];

  final List<String> _statusFlowPenjualan = [
    'Pesanan Masuk',
    'Dikemas',
    'Dikirim',
    'Selesai',
  ];

  List<String> get _statusFlow => widget.type == 'pembelian'
      ? _statusFlowPembelian
      : _statusFlowPenjualan;

  int get _statusIndex {
    if (widget.type == 'penjualan') {
      switch (_currentStatus) {
        case 'Perlu Dikirim': return 1;
        case 'Dikemas': return 1;
        case 'Dikirim': return 2;
        case 'Selesai': return 3;
        default: return 0;
      }
    }
    return _statusFlowPembelian.indexOf(_currentStatus);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai': return _textSecondary;
      case 'Dikirim': return _primary;
      case 'Dikemas': return _primary;
      case 'Perlu Dikirim': return const Color(0xFFE65100);
      case 'Menunggu Konfirmasi': return const Color(0xFFE65100);
      default: return _textSecondary;
    }
  }

  void _showKonfirmasiTerima() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pesanan Diterima',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
        content: const Text('Apakah kamu sudah menerima barang dengan kondisi baik?',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _currentStatus = 'Selesai');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pesanan telah dikonfirmasi selesai!'),
                    backgroundColor: Color(0xFF2e7d32)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e7d32),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Sudah Diterima'),
          ),
        ],
      ),
    );
  }

  void _showKonfirmasiKirim() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kirim Barang',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary)),
        content: const Text('Konfirmasi bahwa kamu sudah mengirimkan barang ke pembeli?',
            style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _currentStatus = 'Dikirim');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Barang berhasil dikonfirmasi dikirim!'),
                    backgroundColor: _primary),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Sudah Dikirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final isPembelian = widget.type == 'pembelian';
    final statusColor = _statusColor(_currentStatus);
    final qty = int.tryParse(o['qty'] ?? '1') ?? 1;

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
              padding: const EdgeInsets.fromLTRB(4, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('Detail Pesanan',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
            ),

            // ── Body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Nomor Invoice & Status ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Nomor Invoice', style: TextStyle(fontSize: 11, color: _textSecondary)),
                                  const SizedBox(height: 2),
                                  Text(o['inv']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: statusColor.withOpacity(0.3)),
                                ),
                                child: Text(_currentStatus,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Tanggal: ${o['date']}', style: const TextStyle(fontSize: 12, color: _textSecondary)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Progress Status ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status Pesanan',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                          const SizedBox(height: 16),
                          Row(
                            children: List.generate(_statusFlow.length, (i) {
                              final isActive = i <= _statusIndex;
                              final isLast = i == _statusFlow.length - 1;
                              return Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 28, height: 28,
                                            decoration: BoxDecoration(
                                              color: isActive ? _primary : _surface,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: isActive ? _primary : _accent, width: 2),
                                            ),
                                            child: Icon(_statusIcon(i), size: 14,
                                                color: isActive ? Colors.white : _textSecondary),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(_statusFlow[i],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                                                  color: isActive ? _primary : _textSecondary)),
                                        ],
                                      ),
                                    ),
                                    if (!isLast)
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          margin: const EdgeInsets.only(bottom: 22),
                                          color: i < _statusIndex ? _primary : _accent,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Info Produk ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Info Produk',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(
                                  color: _accent.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.image_outlined, color: _textSecondary, size: 30),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(o['name']!,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                                    const SizedBox(height: 4),
                                    Text(
                                      isPembelian ? 'Penjual: ${o['seller']}' : 'Pembeli: ${o['buyer']}',
                                      style: const TextStyle(fontSize: 12, color: _textSecondary),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(o['price']!,
                                        style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 16)),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _accent.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.shopping_bag_outlined, size: 13, color: _primary),
                                          const SizedBox(width: 5),
                                          Text('Jumlah: $qty item',
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _primary)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Info Pengiriman ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Info Pengiriman',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                          const SizedBox(height: 12),
                          if (isPembelian) ...[
                            _DetailRow(icon: Icons.location_on_outlined, label: 'Lokasi Penjual', value: 'Jember, Jawa Timur'),
                            const SizedBox(height: 10),
                            _DetailRow(icon: Icons.home_outlined, label: 'Alamat Pengiriman', value: 'Jl. Contoh No. 123, Jember'),
                            const SizedBox(height: 10),
                            // Nomor telepon penjual
                            _DetailRow(
                              icon: Icons.phone_outlined,
                              label: 'No. Telepon Penjual',
                              value: o['sellerPhone'] ?? '08123456789',
                            ),
                          ] else ...[
                            _DetailRow(icon: Icons.person_outline, label: 'Nama Pembeli', value: o['buyer'] ?? '-'),
                            const SizedBox(height: 10),
                            _DetailRow(icon: Icons.home_outlined, label: 'Alamat Tujuan', value: 'Jl. Pembeli No. 456, Jember'),
                            const SizedBox(height: 10),
                            // Nomor telepon pembeli
                            _DetailRow(
                              icon: Icons.phone_outlined,
                              label: 'No. Telepon Pembeli',
                              value: o['buyerPhone'] ?? '08123456789',
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Ringkasan Pembayaran ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ringkasan Pembayaran',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                          const SizedBox(height: 12),
                          _PayRow(label: 'Harga Produk (x$qty)', value: o['price']!),
                          const SizedBox(height: 6),
                          _PayRow(label: 'Biaya Pengiriman', value: 'Rp10.000'),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: _surface),
                          ),
                          _PayRow(label: 'Total', value: o['price']!, isBold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (isPembelian && _currentStatus == 'Dikirim')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showKonfirmasiTerima,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2e7d32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Pesanan Diterima',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        ),
                      ),

                    if (!isPembelian && _currentStatus == 'Perlu Dikirim')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showKonfirmasiKirim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Kirim Barang',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                        ),
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(int index) {
    switch (index) {
      case 0: return Icons.access_time;
      case 1: return Icons.inventory_2_outlined;
      case 2: return Icons.local_shipping_outlined;
      case 3: return Icons.check;
      default: return Icons.circle;
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: _primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: _textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow({required this.label, required this.value, this.isBold = false});
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: isBold ? _textPrimary : _textSecondary,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w400)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                color: isBold ? _primary : _textPrimary,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}