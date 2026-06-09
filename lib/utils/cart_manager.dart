import 'package:flutter/material.dart';

class CartManager extends ChangeNotifier {
  // Singleton
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  int get totalItems => _items.length;

  void addProduct(Map<String, String> product, {int qty = 1}) {
    // Cek apakah produk sudah ada di keranjang
    final index = _items.indexWhere((i) => i['name'] == product['name']);
    if (index != -1) {
      _items[index]['qty'] = (_items[index]['qty'] as int) + qty;
    } else {
      _items.add({
        'name': product['name'] ?? '',
        'price': int.tryParse(
                product['price']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ??
            0,
        'badge': product['badge'] ?? 'SECOND',
        'loc': product['loc'] ?? '-',
        'seller': 'Nama Penjual',
        'qty': qty,
        'selected': true,
      });
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQty(int index, int qty) {
    if (qty <= 0) {
      removeItem(index);
    } else {
      _items[index]['qty'] = qty;
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