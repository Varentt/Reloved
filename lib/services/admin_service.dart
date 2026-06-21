import 'package:reloved/services/supabase_service.dart';

class AdminService {
  // 1. Ambil jumlah total pengguna
  Stream<int> get totalUsersCount {
    return SupabaseService.client
        .from('users')
        .stream(primaryKey: ['id'])
        .map((maps) => maps.length);
  }

  // 2. Ambil jumlah total produk (semua status)
  Stream<int> get totalProductsCount {
    return SupabaseService.client
        .from('products')
        .stream(primaryKey: ['id'])
        .map((maps) => maps.length);
  }

  // 3. Ambil jumlah transaksi sukses
  Stream<int> get totalSalesCount {
    return SupabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('status', 'Selesai')
        .map((maps) => maps.length);
  }

  // 4. Ambil daftar pengguna untuk dikelola
  Stream<List<Map<String, dynamic>>> get usersList {
    return SupabaseService.client
        .from('users')
        .stream(primaryKey: ['id']);
  }

  // 5. Update role pengguna
  Future<void> updateUserRole(String id, String role) async {
    try {
      await SupabaseService.client
          .from('users')
          .update({'role': role})
          .eq('id', id);
    } catch (e) {
      // Handle error
    }
  }
}
