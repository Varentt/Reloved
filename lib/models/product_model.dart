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
  final int stock;

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
    this.stock = 1,
  });

  // Konversi dari Supabase / Firestore Map ke Object
  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    final rawTime = data['created_at'] ?? data['createdAt'];
    final parsedTime = rawTime != null
        ? DateTime.parse(rawTime.toString()).toLocal()
        : DateTime.now();

    return ProductModel(
      id: documentId,
      ownerId: data['owner_id'] ?? data['ownerId'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      normalPrice: data['normal_price'] ?? data['normalPrice'] ?? 0,
      category: data['category'] ?? 'Lainnya',
      condition: data['condition'] ?? 'Bekas',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? data['imageUrl'] ?? '',
      status: data['status'] ?? 'Pending',
      createdAt: parsedTime,
      stock: data['stock'] ?? 1,
    );
  }

  // Konversi ke Map untuk Supabase
  Map<String, dynamic> toSupabaseMap() {
    return {
      'owner_id': ownerId,
      'name': name,
      'price': price,
      'normal_price': normalPrice,
      'category': category,
      'condition': condition,
      'location': location,
      'description': description,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'stock': stock,
    };
  }
}
