import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:reloved/models/product_model.dart';
import 'package:reloved/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  // Helper to map ProductModel to Supabase map
  Map<String, dynamic> _toSupabaseMap(ProductModel product) {
    return {
      'owner_id': product.ownerId,
      'name': product.name,
      'price': product.price,
      'normal_price': product.normalPrice,
      'category': product.category,
      'condition': product.condition,
      'location': product.location,
      'description': product.description,
      'image_url': product.imageUrl,
      'status': product.status,
    };
  }

  // Helper to map Supabase map to ProductModel
  ProductModel _fromSupabaseMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id']?.toString() ?? '',
      ownerId: data['owner_id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      normalPrice: data['normal_price'] ?? 0,
      category: data['category'] ?? 'Lainnya',
      condition: data['condition'] ?? 'Bekas',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      status: data['status'] ?? 'Pending',
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']).toLocal() 
          : DateTime.now(),
    );
  }

  // Upload foto produk ke Supabase Storage
  Future<String> uploadProductImage({
    required String ownerId,
    required String filePath,
    Uint8List? webBytes,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'Ji4KHkH5bwYRO4HMhJ8saWIN0863/$fileName';

    final bytes = kIsWeb && webBytes != null 
        ? webBytes 
        : await File(filePath).readAsBytes();

    // Upload to Supabase bucket 'Reloved'
    await SupabaseService.client.storage
        .from('Reloved')
        .uploadBinary(
          path, 
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    // Get public URL
    final downloadUrl = SupabaseService.client.storage
        .from('Reloved')
        .getPublicUrl(path);

    return downloadUrl;
  }

  // 1. Simpan Produk Baru
  Future<String?> addProduct(ProductModel product) async {
    try {
      await SupabaseService.client.from('products').insert(_toSupabaseMap(product));
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Ambil Daftar Produk (Real-time Stream)
  // Hanya ambil produk yang statusnya 'Aktif'
  Stream<List<ProductModel>> get activeProductsStream {
    return SupabaseService.client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('status', 'Aktif')
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => _fromSupabaseMap(map)).toList());
  }

  // 3. Ambil Produk Milik User Tertentu (Toko Saya)
  Stream<List<ProductModel>> getMyProducts(String uid) {
    return SupabaseService.client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('owner_id', uid)
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => _fromSupabaseMap(map)).toList());
  }

  // 4. Ambil Produk Yang Perlu Verifikasi (Admin)
  Stream<List<ProductModel>> get pendingProductsStream {
    return SupabaseService.client
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('status', 'Pending')
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => _fromSupabaseMap(map)).toList());
  }

  // 5. Update Status Produk (misal: Tandai Terjual, Approve Admin, Reject Admin)
  Future<void> updateProductStatus(String productId, String newStatus) async {
    try {
      await SupabaseService.client
          .from('products')
          .update({'status': newStatus})
          .eq('id', productId);
    } catch (e) {
      print("Error update status: $e");
    }
  }

  // 6. Hapus Produk
  Future<void> deleteProduct(String productId) async {
    await SupabaseService.client
        .from('products')
        .delete()
        .eq('id', productId);
  }

  // 7. Update Detail Produk
  Future<String?> updateProduct(ProductModel product) async {
    try {
      await SupabaseService.client
          .from('products')
          .update({
            'name': product.name,
            'price': product.price,
            'normal_price': product.normalPrice,
            'category': product.category,
            'condition': product.condition,
            'location': product.location,
            'description': product.description,
            'image_url': product.imageUrl,
            'status': product.status,
          })
          .eq('id', product.id);
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }
}
