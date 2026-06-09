import 'package:flutter/material.dart';
import 'package:reloved/screens/login_screen.dart';

// ── Mock Data ──
final _mockPengguna = [
  {'id': '001', 'nama': 'Budi Santoso',  'email': 'budi@gmail.com',  'status': 'aktif'},
  {'id': '002', 'nama': 'Sari Dewi',     'email': 'sari@gmail.com',  'status': 'aktif'},
  {'id': '003', 'nama': 'Rizky Pratama', 'email': 'rizky@gmail.com', 'status': 'nonaktif'},
  {'id': '004', 'nama': 'Mega Putri',    'email': 'mega@gmail.com',  'status': 'aktif'},
  {'id': '005', 'nama': 'Andi Wijaya',   'email': 'andi@gmail.com',  'status': 'aktif'},
];

final _mockProdukPending = [
  {'id': 'P001', 'nama': 'Sepatu Vans Second',    'penjual': 'Budi Santoso', 'kategori': 'SECOND',  'harga': 'Rp150.000', 'waktu': '2 jam lalu'},
  {'id': 'P002', 'nama': 'Mouse Logitech Reject', 'penjual': 'Sari Dewi',    'kategori': 'REJECT',  'harga': 'Rp45.000',  'waktu': '5 jam lalu'},
  {'id': 'P003', 'nama': 'Roti Sobek',            'penjual': 'Mega Putri',   'kategori': 'EXPIRED', 'harga': 'Rp5.000',   'waktu': '1 hari lalu'},
  {'id': 'P004', 'nama': 'Kaos Uniqlo',           'penjual': 'Andi Wijaya',  'kategori': 'SECOND',  'harga': 'Rp50.000',  'waktu': '1 hari lalu'},
];

final _mockSemuaProduk = [
  {'nama': 'Sepatu Vans Second',    'penjual': 'Budi Santoso', 'kategori': 'SECOND',  'harga': 'Rp150.000', 'status': 'Aktif'},
  {'nama': 'Kaos Uniqlo',          'penjual': 'Sari Dewi',    'kategori': 'SECOND',  'harga': 'Rp50.000',  'status': 'Aktif'},
  {'nama': 'Mouse Logitech Reject', 'penjual': 'Mega Putri',   'kategori': 'REJECT',  'harga': 'Rp45.000',  'status': 'Aktif'},
  {'nama': 'Keyboard Mechanical',  'penjual': 'Andi Wijaya',  'kategori': 'REJECT',  'harga': 'Rp120.000', 'status': 'Aktif'},
  {'nama': 'Roti Sobek',           'penjual': 'Budi Santoso', 'kategori': 'EXPIRED', 'harga': 'Rp5.000',   'status': 'Aktif'},
  {'nama': 'Susu UHT',             'penjual': 'Sari Dewi',    'kategori': 'EXPIRED', 'harga': 'Rp3.000',   'status': 'Aktif'},
  {'nama': 'Jaket Denim Levis',    'penjual': 'Mega Putri',   'kategori': 'SECOND',  'harga': 'Rp180.000', 'status': 'Terjual'},
  {'nama': 'Tas Ransel Polo',      'penjual': 'Andi Wijaya',  'kategori': 'SECOND',  'harga': 'Rp80.000',  'status': 'Terjual'},
];

final _mockTransaksi = [
  {'inv': 'INV-2026001', 'produk': 'Kemeja Flanel Uniqlo',   'pembeli': 'Rizky P.',  'penjual': 'Budi S.',  'harga': 'Rp85.000',  'status': 'Selesai',  'tanggal': '24 Mei 2026'},
  {'inv': 'INV-2026002', 'produk': 'Buku Harry Potter',      'pembeli': 'Mega P.',   'penjual': 'Sari D.',  'harga': 'Rp45.000',  'status': 'Selesai',  'tanggal': '20 Mei 2026'},
  {'inv': 'INV-2026003', 'produk': 'Roti Sobek',             'pembeli': 'Andi W.',   'penjual': 'Mega P.',  'harga': 'Rp5.000',   'status': 'Dikirim',  'tanggal': '25 Mei 2026'},
  {'inv': 'INV-2026004', 'produk': 'Kamera Analog Canon',    'pembeli': 'Budi S.',   'penjual': 'Rizky P.', 'harga': 'Rp450.000', 'status': 'Dikirim',  'tanggal': '25 Mei 2026'},
  {'inv': 'INV-2026005', 'produk': 'Sepatu Vans Second',     'pembeli': 'Sari D.',   'penjual': 'Andi W.',  'harga': 'Rp150.000', 'status': 'Selesai',  'tanggal': '18 Mei 2026'},
  {'inv': 'INV-2026006', 'produk': 'Mouse Logitech Reject',  'pembeli': 'Mega P.',   'penjual': 'Budi S.',  'harga': 'Rp45.000',  'status': 'Menunggu', 'tanggal': '26 Mei 2026'},
];

// ─────────────────────────────────────────
//  ADMIN DASHBOARD SCREEN
// ─────────────────────────────────────────
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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
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
  }
}

// ─────────────────────────────────────────
//  SIDE NAV
// ─────────────────────────────────────────
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
      {'icon': Icons.inventory_2_outlined,   'label': 'Total Produk'},
      {'icon': Icons.shopping_bag_outlined,  'label': 'Transaksi'},
      {'icon': Icons.notifications_outlined, 'label': 'Notifikasi'},
    ];

    return Container(
      width: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2e4a73), Color(0xFF3B5B8A), Color(0xFF4a6fa0)],
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
                border: Border.all(color: const Color(0xFFD0E2F2).withOpacity(0.4), width: 1.5),
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFD0E2F2), size: 26),
            ),
            const SizedBox(height: 8),
            const Text('Reloved',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            const Text('Admin Panel', style: TextStyle(color: Color(0xFFD0E2F2), fontSize: 11)),
            const SizedBox(height: 32),
            ...List.generate(items.length, (i) {
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
                          color: active ? Colors.white : const Color(0xFFD0E2F2).withOpacity(0.7), size: 20),
                      const SizedBox(width: 10),
                      Text(items[i]['label'] as String,
                          style: TextStyle(
                              color: active ? Colors.white : const Color(0xFFD0E2F2).withOpacity(0.7),
                              fontWeight: active ? FontWeight.w700 : FontWeight.normal,
                              fontSize: 13)),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            GestureDetector(
              onTap: () => _confirmLogout(context),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    SizedBox(width: 10),
                    Text('Keluar', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Yakin ingin keluar dari admin panel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF3B5B8A))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  DASHBOARD PAGE
// ─────────────────────────────────────────
class _DashboardPage extends StatelessWidget {
  const _DashboardPage({required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start, // cards di atas
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat Datang,',
                        style: TextStyle(fontSize: 13, color: Color(0xFF7a8fa6))),
                    Text('Admin Reloved',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2535))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B5B8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF3B5B8A)),
                      SizedBox(width: 6),
                      Text('Hari ini', style: TextStyle(fontSize: 12, color: Color(0xFF3B5B8A), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Stat cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people_outline,
                    label: 'Total Pengguna',
                    value: '${_mockPengguna.length}',
                    color: const Color(0xFF3B5B8A),
                    onTap: () => onNavigate(1),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Total Produk',
                    value: '${_mockSemuaProduk.length}',
                    color: const Color(0xFF3B5B8A),
                    onTap: () => onNavigate(3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending_outlined,
                    label: 'Pending Verifikasi',
                    value: '${_mockProdukPending.length}',
                    color: const Color(0xFF3B5B8A),
                    onTap: () => onNavigate(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Total Transaksi',
                    value: '${_mockTransaksi.length}',
                    color: const Color(0xFF3B5B8A),
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
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF7a8fa6)),
              ],
            ),
            const SizedBox(height: 14),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF7a8fa6))),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TOTAL PRODUK PAGE
// ─────────────────────────────────────────
class _TotalProdukPage extends StatelessWidget {
  const _TotalProdukPage();

  @override
  Widget build(BuildContext context) {
    final aktif   = _mockSemuaProduk.where((p) => p['status'] == 'Aktif').length;
    final terjual = _mockSemuaProduk.where((p) => p['status'] == 'Terjual').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text('Total Produk',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2535))),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  _MiniStat(label: 'Total', value: '${_mockSemuaProduk.length}'),
                  const SizedBox(width: 24),
                  _MiniStat(label: 'Aktif', value: '$aktif'),
                  const SizedBox(width: 24),
                  _MiniStat(label: 'Terjual', value: '$terjual'),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFD0E2F2)),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _mockSemuaProduk.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final p = _mockSemuaProduk[i];
                  final isAktif = p['status'] == 'Aktif';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD0E2F2).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.image_outlined, color: Color(0xFF7a8fa6), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(p['nama']!,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1a2535))),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B5B8A).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(p['kategori']!,
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF3B5B8A))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text('Penjual: ${p['penjual']}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(p['harga']!,
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF3B5B8A))),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isAktif
                                          ? const Color(0xFF3B5B8A).withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(p['status']!,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: isAktif ? const Color(0xFF3B5B8A) : Colors.grey)),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TOTAL TRANSAKSI PAGE
// ─────────────────────────────────────────
class _TotalTransaksiPage extends StatelessWidget {
  const _TotalTransaksiPage();

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':  return const Color(0xFF3B5B8A);
      case 'Dikirim':  return const Color(0xFF3B5B8A);
      case 'Menunggu': return const Color(0xFF3B5B8A);
      default:         return const Color(0xFF7a8fa6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selesai  = _mockTransaksi.where((t) => t['status'] == 'Selesai').length;
    final dikirim  = _mockTransaksi.where((t) => t['status'] == 'Dikirim').length;
    final menunggu = _mockTransaksi.where((t) => t['status'] == 'Menunggu').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Total Transaksi',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2535))),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  _MiniStat(label: 'Total', value: '${_mockTransaksi.length}'),
                  const SizedBox(width: 24),
                  _MiniStat(label: 'Selesai', value: '$selesai'),
                  const SizedBox(width: 24),
                  _MiniStat(label: 'Dikirim', value: '$dikirim'),
                  const SizedBox(width: 24),
                  _MiniStat(label: 'Menunggu', value: '$menunggu'),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFD0E2F2)),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _mockTransaksi.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final t = _mockTransaksi[i];
                  final statusColor = _statusColor(t['status']!);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(t['inv']!,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7a8fa6))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: statusColor.withOpacity(0.3)),
                                ),
                                child: Text(t['status']!,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag_outlined, size: 14, color: Color(0xFF7a8fa6)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(t['produk']!,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1a2535))),
                                  ),
                                  Text(t['harga']!,
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF3B5B8A))),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 13, color: Color(0xFF7a8fa6)),
                                  const SizedBox(width: 4),
                                  Text('Pembeli: ${t['pembeli']}',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.store_outlined, size: 13, color: Color(0xFF7a8fa6)),
                                  const SizedBox(width: 4),
                                  Text('Penjual: ${t['penjual']}',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
                                  const Spacer(),
                                  Text(t['tanggal']!,
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF3B5B8A))),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  KELOLA PENGGUNA PAGE — view only, tanpa tambah
// ─────────────────────────────────────────
class _KelolapenggunaPage extends StatelessWidget {
  const _KelolapenggunaPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Data Pengguna',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2535))),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    // Header tabel
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFf7fbff),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        border: Border(bottom: BorderSide(color: Color(0xFFD0E2F2), width: 1)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(flex: 1, child: Text('ID',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF3B5B8A)))),
                          Expanded(flex: 3, child: Text('Nama',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF3B5B8A)))),
                          Expanded(flex: 4, child: Text('Email',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF3B5B8A)))),
                          Expanded(flex: 2, child: Text('Status',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF3B5B8A)))),
                        ],
                      ),
                    ),
                    // Rows
                    Expanded(
                      child: ListView.separated(
                        itemCount: _mockPengguna.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFf0f4f8)),
                        itemBuilder: (context, i) {
                          final p = _mockPengguna[i];
                          final isAktif = p['status'] == 'aktif';
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(flex: 1,
                                    child: Text(p['id']!, style: const TextStyle(fontSize: 12, color: Color(0xFF7a8fa6)))),
                                Expanded(flex: 3,
                                    child: Text(p['nama']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                                Expanded(flex: 4,
                                    child: Text(p['email']!, style: const TextStyle(fontSize: 12, color: Color(0xFF7a8fa6)))),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isAktif
                                          ? const Color(0xFF3B5B8A).withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isAktif ? 'Aktif' : 'Nonaktif',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isAktif ? const Color(0xFF3B5B8A) : Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  VERIFIKASI PRODUK PAGE
// ─────────────────────────────────────────
class _VerifikasiProdukPage extends StatefulWidget {
  const _VerifikasiProdukPage();

  @override
  State<_VerifikasiProdukPage> createState() => _VerifikasiProdukPageState();
}

class _VerifikasiProdukPageState extends State<_VerifikasiProdukPage> {
  final List<Map<String, String>> _produk = List.from(_mockProdukPending);

  void _konfirmasi(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${_produk[index]['nama']}" berhasil dikonfirmasi'),
          backgroundColor: const Color(0xFF3B5B8A)),
    );
    setState(() => _produk.removeAt(index));
  }

  void _tolak(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tolak Produk', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Yakin ingin menolak "${_produk[index]['nama']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF3B5B8A))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _produk.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produk ditolak'), backgroundColor: Colors.redAccent));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Tolak', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verifikasi Produk',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2535))),
            const SizedBox(height: 4),
            Text('${_produk.length} produk menunggu verifikasi',
                style: const TextStyle(fontSize: 13, color: Color(0xFF7a8fa6))),
            const SizedBox(height: 20),
            Expanded(
              child: _produk.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 64, color: Color(0xFF3B5B8A)),
                          SizedBox(height: 12),
                          Text('Semua produk sudah diverifikasi!',
                              style: TextStyle(color: Color(0xFF7a8fa6), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _produk.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _ProdukPendingTile(
                        produk: _produk[i],
                        onKonfirmasi: () => _konfirmasi(i),
                        onTolak: () => _tolak(i),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  NOTIFIKASI PAGE
// ─────────────────────────────────────────
class _NotifikasiPage extends StatelessWidget {
  const _NotifikasiPage();

  @override
  Widget build(BuildContext context) {
    final notifs = [
      {'icon': Icons.new_releases_outlined, 'color': const Color(0xFF3B5B8A),
        'judul': 'Produk Baru Perlu Diverifikasi', 'isi': 'Budi Santoso mengunggah "Sepatu Vans Second"', 'waktu': '2 jam lalu'},
      {'icon': Icons.new_releases_outlined, 'color': const Color(0xFF3B5B8A),
        'judul': 'Produk Baru Perlu Diverifikasi', 'isi': 'Sari Dewi mengunggah "Mouse Logitech Reject"', 'waktu': '5 jam lalu'},
      {'icon': Icons.person_add_outlined, 'color': const Color(0xFF3B5B8A),
        'judul': 'Pengguna Baru Terdaftar', 'isi': 'Mega Putri baru saja mendaftar', 'waktu': '1 hari lalu'},
      {'icon': Icons.new_releases_outlined, 'color': const Color(0xFF3B5B8A),
        'judul': 'Produk Baru Perlu Diverifikasi', 'isi': 'Mega Putri mengunggah "Roti Sobek"', 'waktu': '1 hari lalu'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifikasi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2535))),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: notifs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final n = notifs[i];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (n['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n['judul'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1a2535))),
                              const SizedBox(height: 2),
                              Text(n['isi'] as String,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF7a8fa6))),
                            ],
                          ),
                        ),
                        Text(n['waktu'] as String,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SHARED WIDGETS
// ─────────────────────────────────────────
class _ProdukPendingTile extends StatelessWidget {
  const _ProdukPendingTile({
    required this.produk,
    required this.onKonfirmasi,
    required this.onTolak,
  });
  final Map<String, String> produk;
  final VoidCallback onKonfirmasi;
  final VoidCallback onTolak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: const Color(0xFFf0f4f8), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.image_outlined, color: Color(0xFF7a8fa6), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(produk['nama']!,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1a2535))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B5B8A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(produk['kategori']!,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF3B5B8A))),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Oleh: ${produk['penjual']}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF7a8fa6))),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(produk['harga']!,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF3B5B8A))),
                    const Spacer(),
                    Text(produk['waktu']!, style: const TextStyle(fontSize: 11, color: Color(0xFF7a8fa6))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            children: [
              ElevatedButton(
                onPressed: onKonfirmasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5B8A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(88, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Konfirmasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: onTolak,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(88, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Tolak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}