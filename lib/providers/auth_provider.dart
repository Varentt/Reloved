import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:reloved/models/user_model.dart';
import 'package:reloved/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // Inisialisasi: Pantau status login secara otomatis
  AuthProvider() {
    _authService.userStream.listen((User? supabaseUser) async {
      if (supabaseUser != null) {
        // Ambil role & data lengkap dari Supabase
        _user = await _authService.getUserData(supabaseUser.id);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Fungsi Login
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    String? error = await _authService.login(email: email, password: password);
    
    _isLoading = false;
    notifyListeners();
    return error;
  }

  // Fungsi Register
  Future<String?> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    String? error = await _authService.register(
      name: name,
      email: email,
      password: password,
    );
    
    _isLoading = false;
    notifyListeners();
    return error;
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Fungsi Update Profile (termasuk upload foto jika ada)
  Future<String?> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
    String? imagePath,
    Uint8List? webBytes,
  }) async {
    if (_user == null) return "User tidak terautentikasi";
    
    _isLoading = true;
    notifyListeners();

    try {
      String? photoUrl;
      if (imagePath != null || webBytes != null) {
        photoUrl = await _authService.uploadProfileImage(
          uid: _user!.uid,
          filePath: imagePath ?? '',
          webBytes: webBytes,
        );
      }

      String? error = await _authService.updateUserData(
        uid: _user!.uid,
        name: name,
        email: email,
        phone: phone,
        bio: bio,
        photoUrl: photoUrl,
      );

      if (error == null) {
        // Ambil ulang data user terbaru
        _user = await _authService.getUserData(_user!.uid);
      }

      _isLoading = false;
      notifyListeners();
      return error;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
