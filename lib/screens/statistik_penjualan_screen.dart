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

class StatistikPenjualanScreen extends StatelessWidget {
  const StatistikPenjualanScreen({super.key});

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    if (user == null)
      return const Scaffold(body: Center(child: Text('Login dulu')));

    final orderService = OrderService();

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Statistik Penjualan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getSellerOrders(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          final allOrders = snapshot.data ?? [];
          final completedOrders = allOrders
              .where((o) => o.status == 'Selesai')
              .toList();
          final totalIncome = completedOrders.fold(
            0,
            (sum, o) => sum + o.price,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total Pendapatan',
                        value: _formatRupiah(totalIncome),
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Produk Terjual',
                        value: '${completedOrders.length}',
                        icon: Icons.inventory_2_outlined,
                        color: _primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Daftar Produk Terjual',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                if (completedOrders.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('Belum ada produk yang terjual'),
                    ),
                  ),

                ...completedOrders.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: _primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatRupiah(item.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: _primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: _textSecondary),
          ),
        ],
      ),
    );
  }
}
