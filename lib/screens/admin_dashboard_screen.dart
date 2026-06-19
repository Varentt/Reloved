import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/screens/login_screen.dart';
import 'package:reloved/services/admin_service.dart';
import 'package:reloved/services/product_service.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _DashboardPage(onNavigate: (i) => setState(() => _selectedIndex = i)),
      const _KelolapenggunaPage(),
      const _VerifikasiProdukPage(),
      const _TotalProdukPage(),
      const _TotalTransaksiPage(),
      const _NotifikasiPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        
        if (isMobile) {
          return Scaffold(
            backgroundColor: _surface,
            appBar: AppBar(
              backgroundColor: _primary,
              elevation: 0,
              title: const Text('Admin Panel', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            drawer: Drawer(
              child: _SideNav(
                selectedIndex: _selectedIndex,
                onSelect: (i) {
                  setState(() => _selectedIndex = i);
                  Navigator.pop(context);
                },
              ),
            ),
            body: _pages[_selectedIndex],
          );
        }

        return Scaffold(
          backgroundColor: _surface,
          body: Row(
            children: [
              _SideNav(
                selectedIndex: _selectedIndex,
                onSelect: (i) => setState(() => _selectedIndex = i),
              ),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard_outlined,     'label': 'Dashboard'},
      {'icon': Icons.people_outline,         'label': 'Pengguna'},
      {'icon': Icons.verified_outlined,      'label': 'Verifikasi'},
      {'icon': Icons.inventory_2_outlined,   'label': 'Semua Produk'},
      {'icon': Icons.shopping_bag_outlined,  'label': 'Transaksi'},
      {'icon': Icons.notifications_outlined, 'label': 'Notifikasi'},
    ];

    return Container(
      width: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primaryDark, _primary, Color(0xFF4a6fa0)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
              ),
              child: const Icon(Icons.admin_panel_settings, color: _accent, size: 26),
            ),
            const SizedBox(height: 8),
            const Text('Reloved',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            const Text('Admin Panel', style: TextStyle(color: _accent, fontSize: 11)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final active = selectedIndex == i;
                  return GestureDetector(
                    onTap: () => onSelect(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: active ? Colors.white.withOpacity(0.18) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: active ? Colors.white.withOpacity(0.3) : Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(items[i]['icon'] as IconData,
                              color: active ? Colors.white : _accent.withOpacity(0.7), size: 20),
                          const SizedBox(width: 10),
                          Text(items[i]['label'] as String,
                              style: TextStyle(
                                  color: active ? Colors.white : _accent.withOpacity(0.7),
                                  fontSize: 13,
                                  fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Keluar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage({required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService();
    final productService = ProductService();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selamat Datang,', style: TextStyle(fontSize: 13, color: _textSecondary)),
            const Text('Admin Reloved', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary)),
            const SizedBox(height: 28),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StreamBuilder<int>(
                    stream: adminService.totalUsersCount,
                    builder: (context, snap) => _StatCard(
                      icon: Icons.people_outline,
                      label: 'Total Pengguna',
                      value: '${snap.data ?? 0}',
                      color: _primary,
                      onTap: () => onNavigate(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  StreamBuilder<int>(
                    stream: adminService.totalProductsCount,
                    builder: (context, snap) => _StatCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Total Produk',
                      value: '${snap.data ?? 0}',
                      color: _primary,
                      onTap: () => onNavigate(3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  StreamBuilder<List<ProductModel>>(
                    stream: productService.pendingProductsStream,
                    builder: (context, snap) => _StatCard(
                      icon: Icons.pending_outlined,
                      label: 'Pending',
                      value: '${snap.data?.length ?? 0}',
                      color: Colors.orange,
                      onTap: () => onNavigate(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  StreamBuilder<int>(
                    stream: adminService.totalSalesCount,
                    builder: (context, snap) => _StatCard(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Transaksi Sukses',
                      value: '${snap.data ?? 0}',
                      color: Colors.green,
                      onTap: () => onNavigate(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 22),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: _textSecondary),
              ],
            ),
            const SizedBox(height: 14),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _VerifikasiProdukPage extends StatelessWidget {
  const _VerifikasiProdukPage();

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        title: const Text('Verifikasi Produk', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: productService.pendingProductsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('Tidak ada produk yang perlu diverifikasi'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: p.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                                ),
                              )
                            : const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Kategori: ${p.category}\nHarga: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(p.price)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => productService.updateProductStatus(p.id, 'Reject'),
                            child: const Text('Tolak', style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () => productService.updateProductStatus(p.id, 'Aktif'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            child: const Text('Setujui'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Fallback pages (placeholder for remaining admin features)
class _KelolapenggunaPage extends StatelessWidget { const _KelolapenggunaPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('Kelola Pengguna Page')); }
class _TotalProdukPage extends StatelessWidget { const _TotalProdukPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('Total Produk Page')); }
class _TotalTransaksiPage extends StatelessWidget { const _TotalTransaksiPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('Total Transaksi Page')); }
class _NotifikasiPage extends StatelessWidget { const _NotifikasiPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('Notifikasi Admin Page')); }
