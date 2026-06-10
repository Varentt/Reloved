import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reloved/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Simpan Produk Baru
  Future<String?> addProduct(ProductModel product) async {
    try {
      await _db.collection('products').add(product.toMap());
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Ambil Daftar Produk (Real-time Stream)
  // Hanya ambil produk yang statusnya 'Aktif'
  Stream<List<ProductModel>> get activeProductsStream {
    return _db
        .collection('products')
        .where('status', isEqualTo: 'Aktif')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // 3. Ambil Produk Milik User Tertentu (Toko Saya)
  Stream<List<ProductModel>> getMyProducts(String uid) {
    return _db
        .collection('products')
        .where('ownerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // 4. Ambil Produk Yang Perlu Verifikasi (Admin)
  Stream<List<ProductModel>> get pendingProductsStream {
    return _db
        .collection('products')
        .where('status', isEqualTo: 'Pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // 5. Update Status Produk (misal: Tandai Terjual, Approve Admin, Reject Admin)
  Future<void> updateProductStatus(String productId, String newStatus) async {
    try {
      await _db.collection('products').doc(productId).update({
        'status': newStatus,
      });
    } catch (e) {
      print("Error update status: $e");
    }
  }

  // 6. Hapus Produk
  Future<void> deleteProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
  }
}
