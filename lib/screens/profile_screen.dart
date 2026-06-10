import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reloved/models/order_model.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/order_service.dart';
import 'package:reloved/services/product_service.dart';
import 'package:reloved/screens/my_products_screen.dart';
import 'package:reloved/screens/login_screen.dart';
import 'package:reloved/screens/riwayat_transaksi_screen.dart';
import 'package:reloved/screens/daftar_alamat_screen.dart';
import 'package:reloved/screens/statistik_penjualan_screen.dart';
import 'package:reloved/screens/pengaturan_akun_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: _surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Profil ──
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryDark, _primary, Color(0xFF4a6fa0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Profil Saya',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const PengaturanAkunScreen())),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: _accent.withOpacity(0.3),
                              child: const Icon(Icons.person, size: 46, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.name ?? 'Nama Lengkap',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                                const SizedBox(height: 2),
                                Text(user?.email ?? 'user@email.com',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    StreamBuilder<List<OrderModel>>(
                                      stream: OrderService().getBuyerOrders(user?.uid ?? ''),
                                      builder: (context, snapshot) {
                                        final count = snapshot.data?.length ?? 0;
                                        return _StatBadge(label: 'Pembelian', value: '$count');
                                      }
                                    ),
                                    const SizedBox(width: 10),
                                    StreamBuilder<List<ProductModel>>(
                                      stream: ProductService().getMyProducts(user?.uid ?? ''),
                                      builder: (context, snapshot) {
                                        final count = snapshot.data?.length ?? 0;
                                        return _StatBadge(label: 'Penjualan', value: '$count');
                                      }
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Aktivitas Pembeli ──
            _SectionHeader(label: 'Aktivitas Pembeli'),
            _MenuItem(
              icon: Icons.history,
              label: 'Riwayat Transaksi',
              iconColor: _primary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RiwayatTransaksiScreen())),
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              label: 'Daftar Alamat',
              iconColor: _primary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DaftarAlamatScreen())),
            ),

            const SizedBox(height: 16),

            // ── Menu Penjual ──
            _SectionHeader(label: 'Menu Penjual'),
            _MenuItem(
              icon: Icons.inventory_2_outlined,
              label: 'Produk Saya',
              iconColor: _primary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MyProductsScreen())),
            ),
            _MenuItem(
              icon: Icons.analytics_outlined,
              label: 'Statistik Penjualan',
              iconColor: _primary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const StatistikPenjualanScreen())),
            ),

            const SizedBox(height: 16),

            // ── Lainnya ──
            _SectionHeader(label: 'Lainnya'),
            _MenuItem(
              icon: Icons.settings_outlined,
              label: 'Pengaturan Akun',
              iconColor: _textSecondary,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PengaturanAkunScreen())),
            ),
            _MenuItem(
              icon: Icons.logout,
              label: 'Keluar',
              iconColor: Colors.red,
              textColor: Colors.red,
              showArrow: false,
              onTap: () => _confirmLogout(context, authProvider),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: _primary)),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: _textSecondary, letterSpacing: 0.5)),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.textColor,
    this.badge,
    this.showArrow = true,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? textColor;
  final String? badge;
  final bool showArrow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(label,
            style: TextStyle(
                color: textColor ?? _textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(20)),
                child: Text(badge!,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            if (showArrow) ...[
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios, size: 13, color: _textSecondary),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}