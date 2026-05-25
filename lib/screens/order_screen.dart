import 'package:flutter/material.dart';
import 'package:reloved/utils/color_resources.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Pesanan & Transaksi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Pembelian'),
              Tab(text: 'Penjualan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList('pembelian'),
            _buildOrderList('penjualan'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(String type) {
    // Data bohongan untuk pesanan
    final orders = type == 'pembelian' 
      ? [
          {'name': 'Kemeja Flanel Uniqlo', 'price': 'Rp 85.000', 'status': 'Dikirim', 'date': '24 Mei 2026'},
          {'name': 'Buku Harry Potter', 'price': 'Rp 45.000', 'status': 'Selesai', 'date': '20 Mei 2026'},
        ]
      : [
          {'name': 'Kamera Analog Canon', 'price': 'Rp 450.000', 'status': 'Perlu Dikirim', 'date': '25 Mei 2026'},
        ];

    if (orders.isEmpty) {
      return const Center(child: Text('Belum ada transaksi'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order['date']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order['status']!,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getStatusColor(order['status']!)),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(order['price']!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dikirim': return Colors.blue;
      case 'Selesai': return Colors.green;
      case 'Perlu Dikirim': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
