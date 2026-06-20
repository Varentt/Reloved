import 'package:reloved/models/order_model.dart';
import 'package:reloved/services/supabase_service.dart';

class OrderService {
  // 1. Buat Pesanan Baru (Beli)
  Future<String?> createOrder(OrderModel order) async {
    try {
      await SupabaseService.client
          .from('orders')
          .insert(order.toSupabaseMap());
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Ambil Riwayat Pembelian (User sebagai pembeli)
  Stream<List<OrderModel>> getBuyerOrders(String uid) {
    return SupabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('buyer_id', uid)
        .map((maps) {
          final list = maps.map((map) => OrderModel.fromMap(map, map['id']?.toString() ?? '')).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // 3. Ambil Riwayat Penjualan (User sebagai penjual)
  Stream<List<OrderModel>> getSellerOrders(String uid) {
    return SupabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('seller_id', uid)
        .map((maps) {
          final list = maps.map((map) => OrderModel.fromMap(map, map['id']?.toString() ?? '')).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // 4. Update Status Pesanan
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await SupabaseService.client
          .from('orders')
          .update({'status': status})
          .eq('id', orderId);
    } catch (e) {
      print("Error update order status: $e");
    }
  }
}
