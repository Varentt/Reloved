import 'package:flutter/material.dart';
import 'package:reloved/screens/my_products_screen.dart';
import 'package:reloved/utils/color_resources.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'user@email.com',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Premium Member',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bagian Pembeli
            _buildSectionTitle('Aktivitas Pembeli'),
            _buildMenuItem(Icons.shopping_bag_outlined, 'Pesanan Saya'),
            _buildMenuItem(Icons.favorite_border, 'Favorit Saya'),
            _buildMenuItem(Icons.location_on_outlined, 'Daftar Alamat'),

            const SizedBox(height: 24),

            // Bagian Penjual
            _buildSectionTitle('Menu Penjual'),
            _buildMenuItem(
              Icons.storefront_outlined, 
              'Toko Saya', 
              color: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProductsScreen()),
                );
              },
            ),
            _buildMenuItem(Icons.add_box_outlined, 'Tambah Produk Baru'),
            _buildMenuItem(Icons.analytics_outlined, 'Statistik Penjualan'),

            const SizedBox(height: 24),

            // Pengaturan
            _buildSectionTitle('Lainnya'),
            _buildMenuItem(Icons.settings_outlined, 'Pengaturan Akun'),
            _buildMenuItem(Icons.help_outline, 'Pusat Bantuan'),
            _buildMenuItem(Icons.logout, 'Keluar', color: Colors.red, showArrow: false),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color? color, bool showArrow = true, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.textPrimary),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: showArrow 
          ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          : null,
        onTap: onTap,
      ),
    );
  }
}
