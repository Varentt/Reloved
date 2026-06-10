import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/product_service.dart';
import 'package:reloved/screens/add_product_screen.dart';
import 'package:reloved/screens/edit_product_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  String _formatRupiah(int price) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(price);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final productService = ProductService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryDark, _primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: _primary,
        title: const Text('Produk Saya',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: user == null
          ? const Center(child: Text('Silakan login terlebih dahulu'))
          : StreamBuilder<List<ProductModel>>(
              stream: productService.getMyProducts(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final myProducts = snapshot.data ?? [];

                if (myProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.inventory_2_outlined, size: 48, color: _primary),
                        ),
                        const SizedBox(height: 16),
                        const Text('Belum ada produk',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textPrimary)),
                        const SizedBox(height: 6),
                        const Text('Tambah produk pertamamu sekarang!',
                            style: TextStyle(color: _textSecondary, fontSize: 13)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myProducts.length,
                  itemBuilder: (context, index) {
                    final product = myProducts[index];
                    final bool isSold = product.status == 'Terjual';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: product.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.image_outlined, color: _textSecondary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSold ? _surface : _accent.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        product.status,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: isSold ? _textSecondary : _primary,
                                        ),
                                      ),
                                    ),
                                    const Text('Dilihat', // Placeholder views
                                        style: TextStyle(fontSize: 10, color: _textSecondary)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 14, color: _textPrimary)),
                                Text(_formatRupiah(product.price),
                                    style: const TextStyle(
                                        color: _primary, fontWeight: FontWeight.w800, fontSize: 13)),
                                const SizedBox(height: 10),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _SmallButton(
                                        icon: Icons.edit_outlined,
                                        label: 'Edit',
                                        onTap: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => const EditProductScreen())),
                                      ),
                                      const SizedBox(width: 8),
                                      _SmallButton(
                                        icon: Icons.delete_outline,
                                        label: 'Hapus',
                                        onTap: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Hapus Produk'),
                                              content: const Text('Yakin ingin menghapus iklan ini?'),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await productService.deleteProduct(product.id);
                                          }
                                        },
                                        isDestructive: true,
                                      ),
                                      const SizedBox(width: 8),
                                      if (!isSold)
                                        _SmallButton(
                                          icon: Icons.check_circle_outline,
                                          label: 'Tandai Terjual',
                                          onTap: () async {
                                            await productService.updateProductStatus(product.id, 'Terjual');
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddProductScreen())),
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Baru', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : _primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}