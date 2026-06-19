import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Dapatkan stream list productId yang difavoritkan user
  Stream<List<String>> getUserFavoriteProductIds(String uid) {
    return _db
        .collection('favorites')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => doc.data()['productId']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList());
  }

  // 2. Tambah produk ke favorit
  Future<void> addFavorite(String uid, String productId) async {
    try {
      final existing = await _db
          .collection('favorites')
          .where('userId', isEqualTo: uid)
          .where('productId', isEqualTo: productId)
          .get();
      if (existing.docs.isEmpty) {
        await _db.collection('favorites').add({
          'userId': uid,
          'productId': productId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error add favorite: $e");
    }
  }

  // 3. Hapus produk dari favorit
  Future<void> removeFavorite(String uid, String productId) async {
    try {
      final existing = await _db
          .collection('favorites')
          .where('userId', isEqualTo: uid)
          .where('productId', isEqualTo: productId)
          .get();
      for (var doc in existing.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Error remove favorite: $e");
    }
  }

  // 4. Cek apakah produk tertentu difavoritkan oleh user
  Stream<bool> isProductFavorite(String uid, String productId) {
    return _db
        .collection('favorites')
        .where('userId', isEqualTo: uid)
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty);
  }
}
