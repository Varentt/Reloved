import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reloved/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream untuk memantau status login (aktif terus)
  Stream<User?> get userStream => _auth.authStateChanges();

  // Fungsi Registrasi
  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Buat Akun di Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;

      // 2. Simpan Data Tambahan (Nama & Role) ke Firestore
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': 'user', // Default pendaftar baru adalah user biasa
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return e.message; // Kembalikan pesan error
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Ambil Data User Lengkap (termasuk Role dari Firestore)
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Error ambil data user: $e");
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
