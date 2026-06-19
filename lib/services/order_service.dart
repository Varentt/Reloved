import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reloved/models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Buat Pesanan Baru (Beli)
  Future<String?> createOrder(OrderModel order) async {
    try {
      await _db.collection('orders').add(order.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Ambil Riwayat Pembelian (User sebagai pembeli)
  Stream<List<OrderModel>> getBuyerOrders(String uid) {
    return _db
        .collection('orders')
        .where('buyerId', isEqualTo: uid)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // 3. Ambil Riwayat Penjualan (User sebagai penjual)
  Stream<List<OrderModel>> getSellerOrders(String uid) {
    return _db
        .collection('orders')
        .where('sellerId', isEqualTo: uid)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  // 4. Update Status Pesanan
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status});
  }
}
