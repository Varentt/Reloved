class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'admin' atau 'user'

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  // Konversi dari Map (Firestore) ke Object
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'user',
    );
  }

  // Konversi dari Object ke Map (untuk simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
