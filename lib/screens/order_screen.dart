import 'package:flutter/material.dart';
import 'package:reloved/screens/order_detail_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: const Text('Pesanan Saya',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Pembelian'),
              Tab(text: 'Penjualan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _OrderList(type: 'pembelian'),
            _OrderList(type: 'penjualan'),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatefulWidget {
  const _OrderList({required this.type});
  final String type;

  @override
  State<_OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<_OrderList> {
  late List<Map<String, String>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = widget.type == 'pembelian'
        ? [
            {
              'inv': 'INV-2026001',
              'name': 'Kemeja Flanel Uniqlo',
              'price': 'Rp85.000',
              'status': 'Dikirim',
              'date': '24 Mei 2026',
              'seller': 'Reloved Store',
            },
            {
              'inv': 'INV-2026002',
              'name': 'Buku Harry Potter',
              'price': 'Rp45.000',
              'status': 'Selesai',
              'date': '20 Mei 2026',
              'seller': 'Toko Buku Lama',
            },
            {
              'inv': 'INV-2026003',
              'name': 'Roti Sobek',
              'price': 'Rp5.000',
              'status': 'Menunggu Konfirmasi',
              'date': '25 Mei 2026',
              'seller': 'Mega Store',
            },
            {
              'inv': 'INV-2026006',
              'name': 'Kaos Polos Hitam',
              'price': 'Rp35.000',
              'status': 'Dikemas',
              'date': '26 Mei 2026',
              'seller': 'Thrift Corner',
            },
          ]
        : [
            {
              'inv': 'INV-2026004',
              'name': 'Kamera Analog Canon',
              'price': 'Rp450.000',
              'status': 'Perlu Dikirim',
              'date': '25 Mei 2026',
              'buyer': 'Budi S.',
            },
            {
              'inv': 'INV-2026005',
              'name': 'Sepatu Vans Second',
              'price': 'Rp150.000',
              'status': 'Selesai',
              'date': '18 Mei 2026',
              'buyer': 'Sari D.',
            },
            {
              'inv': 'INV-2026007',
              'name': 'Mouse Logitech',
              'price': 'Rp45.000',
              'status': 'Dikemas',
              'date': '26 Mei 2026',
              'buyer': 'Rina A.',
            },
          ];
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return _textSecondary;
      case 'Dikirim':
        return _primary;
      case 'Dikemas':
        return _primary;
      case 'Perlu Dikirim':
        return const Color(0xFFE65100);
      case 'Menunggu Konfirmasi':
        return const Color(0xFFE65100);
      default:
        return _textSecondary;
    }
  }

  bool _hasAction(String type, String status) {
    if (type == 'penjualan' && status == 'Perlu Dikirim') return true;
    if (type == 'pembelian' && status == 'Dikirim') return true;
    return false;
  }

  // Popup konfirmasi untuk pembeli
  void _showKonfirmasiTerima(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Pesanan Diterima',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary),
        ),
        content: const Text(
          'Apakah kamu sudah menerima barang dengan kondisi baik?',
          style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _orders[index] = {..._orders[index], 'status': 'Selesai'};
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan telah dikonfirmasi selesai!'),
                  backgroundColor: Color(0xFF2e7d32),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e7d32),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Sudah Diterima'),
          ),
        ],
      ),
    );
  }

  // Popup konfirmasi untuk penjual kirim barang
  void _showKonfirmasiKirim(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Kirim Barang',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 16, color: _textPrimary),
        ),
        content: const Text(
          'Konfirmasi bahwa kamu sudah mengirimkan barang ke pembeli?',
          style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _orders[index] = {..._orders[index], 'status': 'Dikirim'};
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Barang berhasil dikonfirmasi dikirim!'),
                  backgroundColor: _primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Sudah Dikirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_orders.isEmpty) {
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
              child: const Icon(Icons.assignment_outlined,
                  size: 48, color: _primary),
            ),
            const SizedBox(height: 16),
            const Text('Belum ada transaksi',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _textPrimary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final o = _orders[i];
        final statusColor = _statusColor(o['status']!);
        final hasAction = _hasAction(widget.type, o['status']!);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              // Header: nomor invoice + status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(o['inv']!,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(o['status']!,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor)),
                    ),
                  ],
                ),
              ),

              // Info produk
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.image_outlined,
                          color: _textSecondary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: _textPrimary)),
                          const SizedBox(height: 4),
                          Text(
                            widget.type == 'pembelian'
                                ? 'Penjual: ${o['seller']}'
                                : 'Pembeli: ${o['buyer']}',
                            style: const TextStyle(
                                fontSize: 12, color: _textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(o['price']!,
                              style: const TextStyle(
                                  color: _primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    Text(o['date']!,
                        style: const TextStyle(
                            fontSize: 11, color: _textSecondary)),
                  ],
                ),
              ),

              const Divider(height: 1, color: _surface),

              // Tombol aksi
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailScreen(
                            order: o,
                            type: widget.type,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primary,
                        side: const BorderSide(color: _primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Lihat Detail',
                          style: TextStyle(fontSize: 12)),
                    ),
                    if (hasAction) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.type == 'pembelian') {
                            _showKonfirmasiTerima(context, i);
                          } else {
                            _showKonfirmasiKirim(context, i);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.type == 'pembelian'
                              ? const Color(0xFF2e7d32)
                              : _primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          widget.type == 'pembelian'
                              ? 'Pesanan Diterima'
                              : 'Kirim Barang',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}