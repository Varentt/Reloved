import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reloved/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload foto produk ke Firebase Storage
  Future<String> uploadProductImage({
    required String ownerId,
    required String filePath,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = _storage
        .ref()
        .child('product_images')
        .child(ownerId)
        .child(fileName);
    final uploadTask = await storageRef.putFile(File(filePath));
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

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

  // 7. Update Detail Produk
  Future<String?> updateProduct(ProductModel product) async {
    try {
      await _db.collection('products').doc(product.id).update({
        'name': product.name,
        'price': product.price,
        'normalPrice': product.normalPrice,
        'category': product.category,
        'condition': product.condition,
        'location': product.location,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'status': product.status,
      });
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }
}
