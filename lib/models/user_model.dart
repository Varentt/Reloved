class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'admin' atau 'user'
  final String? photoUrl;
  final String? phone;
  final String? bio;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl,
    this.phone,
    this.bio,
  });

  // Konversi dari Map (Firestore) ke Object
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'user',
      photoUrl: data['photoUrl'],
      phone: data['phone'],
      bio: data['bio'],
    );
  }

  String get displayName => name;

  // Konversi dari Object ke Map (untuk simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'photoUrl': photoUrl,
      'phone': phone,
      'bio': bio,
    };
  }
}
