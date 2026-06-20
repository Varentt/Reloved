import 'package:reloved/services/supabase_service.dart';

class FavoriteService {
  // 1. Dapatkan stream list productId yang difavoritkan user
  Stream<List<String>> getUserFavoriteProductIds(String uid) {
    return SupabaseService.client
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .map((maps) => maps
            .map((map) => map['product_id']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList());
  }

  // 2. Tambah produk ke favorit
  Future<void> addFavorite(String uid, String productId) async {
    try {
      final existing = await SupabaseService.client
          .from('favorites')
          .select()
          .eq('user_id', uid)
          .eq('product_id', productId)
          .maybeSingle();
      
      if (existing == null) {
        await SupabaseService.client.from('favorites').insert({
          'user_id': uid,
          'product_id': productId,
        });
      }
    } catch (e) {
      print("Error add favorite: $e");
    }
  }

  // 3. Hapus produk dari favorit
  Future<void> removeFavorite(String uid, String productId) async {
    try {
      await SupabaseService.client
          .from('favorites')
          .delete()
          .eq('user_id', uid)
          .eq('product_id', productId);
    } catch (e) {
      print("Error remove favorite: $e");
    }
  }

  // 4. Cek apakah produk tertentu difavoritkan oleh user
  Stream<bool> isProductFavorite(String uid, String productId) {
    return SupabaseService.client
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .map((maps) => maps.any((map) => map['product_id'] == productId));
  }
}
