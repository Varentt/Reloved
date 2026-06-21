import 'package:flutter/foundation.dart';
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
      debugPrint("Error update order status: $e");
    }
  }

  // 5. Update Jadwal & Lokasi COD
  Future<void> updateOrderMeetup({
    required String orderId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime time,
    required String meetupStatus,
  }) async {
    try {
      await SupabaseService.client
          .from('orders')
          .update({
            'meetup_location': location,
            'meetup_latitude': latitude,
            'meetup_longitude': longitude,
            'meetup_time': time.toUtc().toIso8601String(),
            'meetup_status': meetupStatus,
          })
          .eq('id', orderId);
    } catch (e) {
      debugPrint("Error update order meetup: $e");
    }
  }

  // 6. Update Status Persetujuan Janjian
  Future<void> updateMeetupStatus(String orderId, String meetupStatus) async {
    try {
      await SupabaseService.client
          .from('orders')
          .update({'meetup_status': meetupStatus})
          .eq('id', orderId);
    } catch (e) {
      debugPrint("Error update meetup status: $e");
    }
  }

  // 7. Ambil Semua Transaksi Sukses (Selesai) untuk Admin
  Stream<List<OrderModel>> get allSuccessfulOrders {
    return SupabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('status', 'Selesai')
        .map((maps) {
          final list = maps.map((map) => OrderModel.fromMap(map, map['id']?.toString() ?? '')).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }
}
