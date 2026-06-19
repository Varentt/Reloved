import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String productId;
  final String productName;
  final int price;
  final int qty;
  final String status; // 'Pending', 'Diproses', 'Dikirim', 'Selesai'
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.productName,
    required this.price,
    this.qty = 1,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String docId) {
    return OrderModel(
      id: docId,
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      price: data['price'] ?? 0,
      qty: data['qty'] ?? 1,
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'qty': qty,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
