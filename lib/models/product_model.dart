import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String ownerId;
  final String name;
  final int price;
  final int normalPrice;
  final String category;
  final String condition;
  final String location;
  final String description;
  final String imageUrl;
  final String status; // 'Pending', 'Aktif', 'Terjual', 'Reject'
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.price,
    required this.normalPrice,
    required this.category,
    required this.condition,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.status = 'Pending', // Default menunggu verifikasi admin
    required this.createdAt,
  });

  // Konversi dari Firestore Map ke Object
  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      normalPrice: data['normalPrice'] ?? 0,
      category: data['category'] ?? 'Lainnya',
      condition: data['condition'] ?? 'Bekas',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Konversi dari Object ke Map untuk simpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'price': price,
      'normalPrice': normalPrice,
      'category': category,
      'condition': condition,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
