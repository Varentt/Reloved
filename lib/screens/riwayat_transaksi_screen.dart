import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/models/order_model.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/order_service.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class RiwayatTransaksiScreen extends StatelessWidget {
  const RiwayatTransaksiScreen({super.key});

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai': return Colors.green;
      case 'Dikirim': return Colors.blue;
      case 'Pending': return Colors.orange;
      case 'Diproses': return Colors.orange;
      default: return _textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    if (user == null) return const Scaffold(body: Center(child: Text('Login dulu')));

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
        title: const Text('Riwayat Pembelian',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderService().getBuyerOrders(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: _accent),
                  const SizedBox(height: 16),
                  const Text('Belum ada transaksi pembelian'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              final statusColor = _statusColor(item.status);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text('INV/${item.id.substring(0,8).toUpperCase()}',
                                style: const TextStyle(fontSize: 11, color: _textSecondary, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(item.status,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: _accent.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.shopping_bag_outlined, color: _primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text('${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                                    style: const TextStyle(fontSize: 12, color: _textSecondary)),
                              ],
                            ),
                          ),
                          Text(_formatRupiah(item.price),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
