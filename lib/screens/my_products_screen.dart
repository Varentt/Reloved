import 'package:flutter/material.dart';
import 'package:reloved/utils/color_resources.dart';
import 'package:reloved/screens/add_product_screen.dart';
import 'package:reloved/screens/edit_product_screen.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data bohongan produk milik user
    final myProducts = [
      {'name': 'Kemeja Flanel Uniqlo', 'price': 'Rp 85.000', 'status': 'Aktif', 'views': '124'},
      {'name': 'Sepatu Converse Bekas', 'price': 'Rp 200.000', 'status': 'Terjual', 'views': '350'},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Produk Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: myProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Anda belum memiliki produk'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myProducts.length,
              itemBuilder: (context, index) {
                final product = myProducts[index];
                final bool isSold = product['status'] == 'Terjual';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Image Placeholder
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_outlined, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      // Info
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
                                    color: isSold ? Colors.grey.shade200 : AppColors.primaryLight.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    product['status']!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSold ? Colors.grey : AppColors.primary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${product['views']} Dilihat',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product['price']!,
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            // Action Buttons
                            Row(
                              children: [
                                _buildSmallButton(Icons.edit_outlined, 'Edit', Colors.blue, () {
                                                                                                Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) => const EditProductScreen(),
                                                                                                  ),
                                                                                                );
                                                                                              }),
                                const SizedBox(width: 8),
                                _buildSmallButton(Icons.delete_outline, 'Hapus', Colors.red, () {}),
                                const Spacer(),
                                if (!isSold)
                                  _buildSmallButton(Icons.check_circle_outline, 'Tandai Terjual', Colors.green, () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Baru', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
