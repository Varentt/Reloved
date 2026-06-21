import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reloved/models/order_model.dart';
import 'package:reloved/models/product_model.dart';
import 'package:reloved/screens/login_screen.dart';
import 'package:reloved/screens/main_navigation_screen.dart';
import 'package:reloved/screens/order_detail_screen.dart';
import 'package:reloved/services/admin_service.dart';
import 'package:reloved/services/order_service.dart';
import 'package:reloved/services/product_service.dart';
import 'package:reloved/services/notification_service.dart';

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
      _KelolapenggunaPage(onBack: () => setState(() => _selectedIndex = 0)),
      _VerifikasiProdukPage(onBack: () => setState(() => _selectedIndex = 0)),
      _TotalProdukPage(onBack: () => setState(() => _selectedIndex = 0)),
      _TotalTransaksiPage(onBack: () => setState(() => _selectedIndex = 0)),
      _NotifikasiPage(onBack: () => setState(() => _selectedIndex = 0)),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: OutlinedButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_outlined, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Ke Aplikasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
            ),
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
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selamat Datang,', style: TextStyle(fontSize: 13, color: _textSecondary)),
                      const Text('Admin Reloved', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
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
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: _textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _VerifikasiProdukPage extends StatefulWidget {
  const _VerifikasiProdukPage({required this.onBack});
  final VoidCallback onBack;

  @override
  State<_VerifikasiProdukPage> createState() => _VerifikasiProdukPageState();
}

class _VerifikasiProdukPageState extends State<_VerifikasiProdukPage> {
  final Set<String> _processedProductIds = {};

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: widget.onBack,
        ),
        title: const Text('Verifikasi Produk', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: productService.pendingProductsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          // Filter out locally processed products
          final products = (snapshot.data ?? [])
              .where((p) => !_processedProductIds.contains(p.id))
              .toList();

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
                            onPressed: () async {
                              setState(() {
                                _processedProductIds.add(p.id);
                              });
                              try {
                                await productService.updateProductStatus(p.id, 'Reject');
                                NotificationService().sendNotification(
                                  userId: p.ownerId,
                                  type: 'reject_product',
                                  title: 'Produk Ditolak Admin',
                                  body: 'Maaf, produk "${p.name}" ditolak oleh admin dan tidak dapat ditampilkan di marketplace.',
                                  data: {
                                    'productName': p.name,
                                  },
                                );
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _processedProductIds.remove(p.id);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Gagal memperbarui status produk: $e')),
                                  );
                                }
                              }
                            },
                            child: const Text('Tolak', style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _processedProductIds.add(p.id);
                              });
                              try {
                                await productService.updateProductStatus(p.id, 'Aktif');
                                NotificationService().sendNotification(
                                  userId: p.ownerId,
                                  type: 'approve_product',
                                  title: 'Produk Disetujui Admin',
                                  body: 'Selamat! Produk "${p.name}" telah disetujui oleh admin dan kini aktif di marketplace.',
                                  data: {
                                    'productId': p.id,
                                    'productName': p.name,
                                  },
                                );
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _processedProductIds.remove(p.id);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Gagal memperbarui status produk: $e')),
                                  );
                                }
                              }
                            },
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
class _KelolapenggunaPage extends StatelessWidget {
  const _KelolapenggunaPage({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: onBack,
        ),
        title: const Text('Kelola Pengguna', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: adminService.usersList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text('Tidak ada pengguna terdaftar'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              final String name = u['name'] ?? 'No Name';
              final String email = u['email'] ?? 'No Email';
              final String role = u['role'] ?? 'user';
              final String phone = u['phone'] ?? '-';
              final String bio = u['bio'] ?? '';
              final isAdmin = role.toLowerCase() == 'admin';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isAdmin ? _primary.withOpacity(0.1) : _accent.withOpacity(0.4),
                                  child: Icon(
                                    isAdmin ? Icons.admin_panel_settings : Icons.person_outline,
                                    color: isAdmin ? _primary : _textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        email,
                                        style: const TextStyle(fontSize: 12, color: _textSecondary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isAdmin ? Colors.green.withOpacity(0.1) : _accent.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isAdmin ? 'Admin' : 'User',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isAdmin ? Colors.green : _textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 14, color: _textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            'Telepon: $phone',
                            style: const TextStyle(fontSize: 12, color: _textPrimary),
                          ),
                        ],
                      ),
                      if (bio.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, size: 14, color: _textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Bio: $bio',
                                style: const TextStyle(fontSize: 12, color: _textPrimary, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ],

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

class _TotalProdukPage extends StatelessWidget {
  const _TotalProdukPage({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: onBack,
        ),
        title: const Text('Semua Produk', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: productService.allProductsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('Tidak ada produk terdaftar'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              final priceFormatted = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(p.price);

              // Tentukan teks status dan warna badge
              String statusText = 'Belum Terjual';
              Color statusColor = Colors.green;
              if (p.status == 'Terjual' || p.stock == 0) {
                statusText = 'Terjual';
                statusColor = Colors.redAccent;
              } else if (p.status == 'Pending') {
                statusText = 'Pending';
                statusColor = Colors.orange;
              } else if (p.status == 'Reject') {
                statusText = 'Ditolak';
                statusColor = Colors.grey;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: p.imageUrl.isNotEmpty
                            ? Image.network(
                                p.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: _accent.withOpacity(0.3),
                                      child: const Icon(Icons.image_outlined, color: Colors.grey),
                                    ),
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: _accent.withOpacity(0.3),
                                child: const Icon(Icons.image_outlined, color: Colors.grey),
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.category,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _primary),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Stok: ${p.stock}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              priceFormatted,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _primary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 12, color: _textSecondary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    p.location,
                                    style: const TextStyle(fontSize: 11, color: _textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

class _TotalTransaksiPage extends StatelessWidget {
  const _TotalTransaksiPage({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: onBack,
        ),
        title: const Text('Total Transaksi', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: _textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.allSuccessfulOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada transaksi sukses'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final o = orders[i];
              final totalFormatted = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(o.price * o.qty);

              final dateFormatted = DateFormat('dd MMM yyyy, HH:mm').format(o.createdAt);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(
                        order: o,
                        type: 'admin',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: Colors.green, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    o.productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ID Transaksi: ${o.id}',
                                    style: const TextStyle(fontSize: 10, color: _textSecondary, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Selesai',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pembayaran', style: TextStyle(fontSize: 11, color: _textSecondary)),
                                const SizedBox(height: 2),
                                Text(
                                  totalFormatted,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _primary),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Jumlah: ${o.qty} barang', style: const TextStyle(fontSize: 11, color: _textSecondary)),
                                const SizedBox(height: 2),
                                Text(
                                  dateFormatted,
                                  style: const TextStyle(fontSize: 11, color: _textPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (o.meetupLocation != null && o.meetupLocation!.isNotEmpty) ...[
                          const Divider(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: _textSecondary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Lokasi/Metode: ${o.meetupLocation}',
                                  style: const TextStyle(fontSize: 12, color: _textPrimary, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
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

class _NotifikasiPage extends StatefulWidget {
  const _NotifikasiPage({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<_NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<_NotifikasiPage> {
  final Set<String> _readNotifIds = {};
  bool _allMarkedRead = false;

  String _getRelativeTime(String createdAtStr) {
    try {
      final parsed = DateTime.parse(createdAtStr).toLocal();
      final diff = DateTime.now().difference(parsed);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return 'Beberapa saat lalu';
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: notificationService.streamNotifications('admin'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: _surface,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: _textPrimary),
                onPressed: widget.onBack,
              ),
              title: const Text('Notifikasi Admin', style: TextStyle(fontWeight: FontWeight.w800)),
              backgroundColor: Colors.white,
              foregroundColor: _textPrimary,
              elevation: 0,
            ),
            body: const Center(child: CircularProgressIndicator(color: _primary)),
          );
        }

        final rawNotifs = snapshot.data ?? [];
        final notifs = rawNotifs.map((n) {
          final id = n['id']?.toString() ?? '';
          final isRead = _allMarkedRead || _readNotifIds.contains(id) || (n['is_read'] as bool? ?? false);
          return {
            ...n,
            'is_read': isRead,
          };
        }).toList();

        final unreadCount = notifs.where((n) => n['is_read'] == false).length;

        return Scaffold(
          backgroundColor: _surface,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: _textPrimary),
              onPressed: widget.onBack,
            ),
            title: const Text('Notifikasi Admin', style: TextStyle(fontWeight: FontWeight.w800)),
            backgroundColor: Colors.white,
            foregroundColor: _textPrimary,
            elevation: 0,
            actions: [
              if (unreadCount > 0)
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _allMarkedRead = true;
                    });
                    try {
                      await notificationService.markAllAsRead('admin');
                    } catch (e) {
                      if (mounted) {
                        setState(() {
                          _allMarkedRead = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal menandai semua dibaca: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Tandai semua dibaca',
                      style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          body: notifs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_none_outlined, size: 48, color: _primary),
                      ),
                      const SizedBox(height: 16),
                      const Text('Belum ada notifikasi admin',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textPrimary)),
                      const SizedBox(height: 6),
                      const Text('Aktivitas upload dan verifikasi produk\nakan muncul di sini',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _textSecondary, fontSize: 13)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (unreadCount > 0)
                      Container(
                        width: double.infinity,
                        color: _accent.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('$unreadCount notifikasi admin belum dibaca',
                            style: const TextStyle(fontSize: 12, color: _primary, fontWeight: FontWeight.w600)),
                      ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final n = notifs[i];
                          final id = n['id']?.toString() ?? '';
                          final isRead = n['is_read'] as bool? ?? false;
                          final title = n['title'] as String? ?? '';
                          final body = n['body'] as String? ?? '';
                          final createdAt = n['created_at'] as String? ?? '';

                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                _readNotifIds.add(id);
                              });
                              try {
                                await notificationService.markAsRead(id);
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _readNotifIds.remove(id);
                                  });
                                }
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isRead ? Colors.white : _accent.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isRead ? Colors.transparent : _primary.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.cloud_upload_outlined,
                                        color: Colors.blue, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(title,
                                                  style: TextStyle(
                                                      fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                                                      fontSize: 13,
                                                      color: _textPrimary)),
                                            ),
                                            if (!isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: _primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(body,
                                            style: const TextStyle(
                                                fontSize: 12, color: _textSecondary, height: 1.4)),
                                        const SizedBox(height: 6),
                                        Text(_getRelativeTime(createdAt),
                                            style: const TextStyle(fontSize: 11, color: _textSecondary)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
