import 'package:flutter/material.dart';

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
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Pembelian'),
              Tab(text: 'Penjualan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrderList(type: 'pembelian'),
            _OrderList(type: 'penjualan'),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.type});
  final String type;

  List<Map<String, String>> get _orders => type == 'pembelian'
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
        ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Dikirim':
        return Colors.blue;
      case 'Selesai':
        return const Color(0xFF2e7d32);
      case 'Perlu Dikirim':
        return const Color(0xFFe65100);
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      default:
        return _textSecondary;
    }
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
              // Header
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

              // Produk info
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
                            type == 'pembelian'
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

              // Divider + tombol
              const Divider(height: 1, color: _surface),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
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
                    if (type == 'penjualan' && o['status'] == 'Perlu Dikirim') ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Kirim Barang',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    if (type == 'pembelian' && o['status'] == 'Dikirim') ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2e7d32),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Konfirmasi Terima',
                            style: TextStyle(fontSize: 12)),
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