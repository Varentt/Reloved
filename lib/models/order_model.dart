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
  final String? meetupLocation;
  final double? meetupLatitude;
  final double? meetupLongitude;
  final DateTime? meetupTime;
  final String meetupStatus; // 'None', 'Proposed', 'Agreed'

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
    this.meetupLocation,
    this.meetupLatitude,
    this.meetupLongitude,
    this.meetupTime,
    this.meetupStatus = 'None',
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String docId) {
    final rawTime = data['created_at'] ?? data['createdAt'];
    final parsedTime = rawTime != null 
        ? DateTime.parse(rawTime.toString()).toLocal() 
        : DateTime.now();

    final rawMeetupTime = data['meetup_time'] ?? data['meetupTime'];
    final parsedMeetupTime = rawMeetupTime != null 
        ? DateTime.parse(rawMeetupTime.toString()).toLocal() 
        : null;

    return OrderModel(
      id: docId,
      buyerId: data['buyer_id'] ?? data['buyerId'] ?? '',
      sellerId: data['seller_id'] ?? data['sellerId'] ?? '',
      productId: data['product_id'] ?? data['productId'] ?? '',
      productName: data['product_name'] ?? data['productName'] ?? '',
      price: data['price'] ?? 0,
      qty: data['qty'] ?? 1,
      status: data['status'] ?? 'Pending',
      createdAt: parsedTime,
      meetupLocation: data['meetup_location'] ?? data['meetupLocation'],
      meetupLatitude: (data['meetup_latitude'] ?? data['meetupLatitude'])?.toDouble(),
      meetupLongitude: (data['meetup_longitude'] ?? data['meetupLongitude'])?.toDouble(),
      meetupTime: parsedMeetupTime,
      meetupStatus: data['meetup_status'] ?? data['meetupStatus'] ?? 'None',
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'qty': qty,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'meetup_location': meetupLocation,
      'meetup_latitude': meetupLatitude,
      'meetup_longitude': meetupLongitude,
      'meetup_time': meetupTime?.toUtc().toIso8601String(),
      'meetup_status': meetupStatus,
    };
  }
}
