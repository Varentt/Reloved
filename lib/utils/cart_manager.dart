import 'package:flutter/material.dart';

class CartManager extends ChangeNotifier {
  // Singleton
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  int get totalItems => _items.length;

  void addProduct({
    required String id,
    required String ownerId,
    required String name,
    required int price,
    required String badge,
    required String imageUrl,
    required String seller,
    required int stock,
    int qty = 1,
  }) {
    // Cek apakah produk sudah ada di keranjang
    final index = _items.indexWhere((i) => i['id'] == id);
    if (index != -1) {
      final newQty = (_items[index]['qty'] as int) + qty;
      _items[index]['qty'] = newQty.clamp(1, stock);
      _items[index]['stock'] = stock;
    } else {
      _items.add({
        'id': id,
        'ownerId': ownerId,
        'name': name,
        'price': price,
        'badge': badge,
        'imageUrl': imageUrl,
        'seller': seller,
        'qty': qty.clamp(1, stock),
        'stock': stock,
        'selected': true,
      });
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void removeItemsByIds(List<String> ids) {
    _items.removeWhere((item) => ids.contains(item['id']));
    notifyListeners();
  }

  void updateQty(int index, int qty) {
    if (qty <= 0) {
      removeItem(index);
    } else {
      final maxStock = _items[index]['stock'] as int? ?? 999999;
      _items[index]['qty'] = qty.clamp(1, maxStock);
      notifyListeners();
    }
  }

  void toggleSelected(int index, bool? val) {
    _items[index]['selected'] = val ?? false;
    notifyListeners();
  }

  void toggleAll(bool? val) {
    for (final item in _items) {
      item['selected'] = val ?? false;
    }
    notifyListeners();
  }

  bool get allSelected =>
      _items.isNotEmpty && _items.every((i) => i['selected'] == true);

  int get totalPrice => _items
      .where((i) => i['selected'] == true)
      .fold(0, (sum, i) => sum + (i['price'] as int) * (i['qty'] as int));

  int get selectedCount =>
      _items.where((i) => i['selected'] == true).length;
}