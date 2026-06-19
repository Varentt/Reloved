import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/models/order_model.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/order_service.dart';
import 'package:reloved/screens/order_detail_screen.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/services/product_service.dart';
import 'package:reloved/services/auth_service.dart';
import 'package:reloved/services/chat_service.dart';
import 'package:reloved/screens/chat_screen.dart';

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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
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

class _OrderList extends StatelessWidget {
  const _OrderList({required this.type});
  final String type;

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai': return Colors.green;
      case 'Dikirim': return Colors.blue;
      case 'Diproses': return Colors.orange;
      case 'Pending': return Colors.orange;
      case 'Batal': return Colors.red;
      default: return _textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    if (user == null) return const Center(child: Text('Silakan login'));

    final orderService = OrderService();
    final productService = ProductService();
    final stream = type == 'pembelian' 
        ? orderService.getBuyerOrders(user.uid) 
        : orderService.getSellerOrders(user.uid);

    return StreamBuilder<List<OrderModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: _accent.withOpacity(0.4), shape: BoxShape.circle),
                  child: const Icon(Icons.assignment_outlined, size: 48, color: _primary),
                ),
                const SizedBox(height: 16),
                const Text('Belum ada transaksi',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textPrimary)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final o = orders[i];
            final statusColor = _statusColor(o.status);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('INV/${o.createdAt.year}/${o.createdAt.month}/${o.id.substring(0, 5).toUpperCase()}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textSecondary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor.withOpacity(0.3)),
                          ),
                          child: Text(o.status,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        FutureBuilder<ProductModel?>(
                          future: productService.getProductById(o.productId),
                          builder: (context, snapshot) {
                            final prod = snapshot.data;
                            return Container(
                              width: 60, height: 60,
                              decoration: BoxDecoration(color: _accent.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                              child: prod != null && prod.imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(prod.imageUrl, fit: BoxFit.cover),
                                    )
                                  : const Icon(Icons.image_outlined, color: _textSecondary),
                            );
                          }
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.productName,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(_formatRupiah(o.price),
                                      style: const TextStyle(color: _primary, fontWeight: FontWeight.w800, fontSize: 14)),
                                  const SizedBox(width: 8),
                                  Text('x${o.qty}',
                                      style: const TextStyle(color: _textSecondary, fontWeight: FontWeight.w600, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text('${o.createdAt.day}/${o.createdAt.month}',
                            style: const TextStyle(fontSize: 11, color: _textSecondary)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: _surface),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (type == 'pembelian' && o.status == 'Pending')
                          ElevatedButton(
                            onPressed: () => _cancelOrder(context, orderService, productService, o),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                            child: const Text('Batalkan Pesanan'),
                          ),
                        if (type == 'pembelian' && o.status == 'Dikirim')
                          ElevatedButton(
                            onPressed: () => _updateStatus(context, orderService, o.id, 'Selesai'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            child: const Text('Pesanan Diterima'),
                          ),
                        if (type == 'penjualan' && o.status == 'Pending') ...[
                          OutlinedButton(
                            onPressed: () => _cancelOrder(context, orderService, productService, o),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            ),
                            child: const Text('Batalkan'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _updateStatus(context, orderService, o.id, 'Diproses'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                            child: const Text('Konfirmasi Pesanan'),
                          ),
                        ],
                        if (type == 'penjualan' && o.status == 'Diproses') ...[
                          OutlinedButton(
                            onPressed: () => _cancelOrder(context, orderService, productService, o),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            ),
                            child: const Text('Batalkan'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _updateStatus(context, orderService, o.id, 'Dikirim'),
                            style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.white),
                            child: const Text('Kirim Barang'),
                          ),
                        ],
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator(color: _primary)),
                            );
                            try {
                              final authService = AuthService();
                              final chatService = ChatService();
                              final otherId = type == 'pembelian' ? o.sellerId : o.buyerId;
                              
                              final otherUser = await authService.getUserData(otherId);
                              final otherName = otherUser?.name ?? 'Pengguna Reloved';
                              
                              final roomId = await chatService.getOrCreateChatRoom(
                                myId: user.uid,
                                myName: user.name,
                                otherId: otherId,
                                otherName: otherName,
                              );
                              
                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      roomId: roomId,
                                      otherId: otherId,
                                      otherName: otherName,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal memulai chat: $e')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text('Chat'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primary,
                            side: const BorderSide(color: _primary, width: 1.2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailScreen(order: o, type: type),
                              ),
                            );
                          },
                          child: const Text('Detail'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateStatus(BuildContext context, OrderService service, String id, String status) async {
    await service.updateOrderStatus(id, status);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status pesanan diperbarui ke $status')),
      );
    }
  }

  void _cancelOrder(BuildContext context, OrderService service, ProductService productService, OrderModel order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Pesanan', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // 1. Update status di Firestore
      await service.updateOrderStatus(order.id, 'Batal');

      // 2. Kembalikan stok di Supabase
      try {
        final prod = await productService.getProductById(order.productId);
        if (prod != null) {
          final newStock = prod.stock + order.qty;
          final updatedProd = ProductModel(
            id: prod.id,
            ownerId: prod.ownerId,
            name: prod.name,
            price: prod.price,
            normalPrice: prod.normalPrice,
            category: prod.category,
            condition: prod.condition,
            location: prod.location,
            description: prod.description,
            imageUrl: prod.imageUrl,
            status: prod.status == 'Terjual' ? 'Aktif' : prod.status,
            stock: newStock,
            createdAt: prod.createdAt,
          );
          await productService.updateProduct(updatedProd);
        }
      } catch (e) {
        debugPrint("Gagal mengembalikan stok produk: $e");
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan berhasil dibatalkan'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}