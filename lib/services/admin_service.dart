import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Ambil jumlah total pengguna
  Stream<int> get totalUsersCount {
    return _db.collection('users').snapshots().map((snap) => snap.docs.length);
  }

  // 2. Ambil jumlah total produk (semua status)
  Stream<int> get totalProductsCount {
    return _db.collection('products').snapshots().map((snap) => snap.docs.length);
  }

  // 3. Ambil jumlah transaksi sukses
  Stream<int> get totalSalesCount {
    return _db
        .collection('orders')
        .where('status', isEqualTo: 'Selesai')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  // 4. Ambil daftar pengguna untuk dikelola
  Stream<List<Map<String, dynamic>>> get usersList {
    return _db.collection('users').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }
}
