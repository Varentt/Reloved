import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:reloved/models/user_model.dart';
import 'package:reloved/services/supabase_service.dart';

class AuthService {
  // Stream untuk memantau status login
  Stream<User?> get userStream => SupabaseService.client.auth.onAuthStateChange
      .map((data) => data.session?.user);

  // Fungsi Registrasi
  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Buat Akun di Supabase Auth
      final AuthResponse response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      final User? user = response.user;

      // 2. Simpan Data Tambahan (Nama & Role) ke tabel users
      if (user != null) {
        await SupabaseService.client.from('users').insert({
          'id': user.id,
          'name': name,
          'email': email,
          'role': 'user', // Default pendaftar baru adalah user biasa
        });
      }
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }

  // Fungsi Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }

  // Ambil Data User Lengkap (termasuk Role dari tabel users)
  Future<UserModel?> getUserData(String uid) async {
    try {
      final data = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle();
      if (data != null) {
        // Map keys dari kolom database PostgreSQL ke field camelCase UserModel
        final userMap = {
          'email': data['email'],
          'name': data['name'],
          'role': data['role'],
          'photoUrl': data['photo_url'],
          'phone': data['phone'],
          'bio': data['bio'],
        };
        return UserModel.fromMap(userMap, uid);
      }
    } catch (e) {
      print("Error ambil data user: $e");
    }
    return null;
  }

  // Update data user di tabel users
  Future<String?> updateUserData({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String bio,
    String? photoUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'name': name,
        'email': email,
        'phone': phone,
        'bio': bio,
      };
      if (photoUrl != null) {
        updateData['photo_url'] = photoUrl;
      }
      await SupabaseService.client
          .from('users')
          .update(updateData)
          .eq('id', uid);
      return null; // Sukses
    } catch (e) {
      return e.toString();
    }
  }

  // Upload foto ke Supabase Storage (Bucket 'Reloved')
  Future<String> uploadProfileImage({
    required String uid,
    required String filePath,
    Uint8List? webBytes,
  }) async {
    final bytes = kIsWeb && webBytes != null
        ? webBytes
        : await File(filePath).readAsBytes();
    final path = 'profile_images/$uid.jpg';

    // Upload ke bucket 'Reloved' (dengan upsert: true)
    await SupabaseService.client.storage
        .from('Reloved')
        .uploadBinary(
          path, 
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    // Dapatkan URL publik
    final downloadUrl = SupabaseService.client.storage
        .from('Reloved')
        .getPublicUrl(path);

    return downloadUrl;
  }

  // Logout
  Future<void> logout() async {
    await SupabaseService.client.auth.signOut();
  }
}
