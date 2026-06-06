import 'package:flutter/material.dart';
import 'package:reloved/screens/login_screen.dart';

// ── Mock Data ──
final _mockPengguna = [
  {'id': '001', 'nama': 'Budi Santoso',   'email': 'budi@gmail.com',   'status': 'aktif'},
  {'id': '002', 'nama': 'Sari Dewi',      'email': 'sari@gmail.com',   'status': 'aktif'},
  {'id': '003', 'nama': 'Rizky Pratama',  'email': 'rizky@gmail.com',  'status': 'nonaktif'},
  {'id': '004', 'nama': 'Mega Putri',     'email': 'mega@gmail.com',   'status': 'aktif'},
  {'id': '005', 'nama': 'Andi Wijaya',    'email': 'andi@gmail.com',   'status': 'aktif'},
];

final _mockProdukPending = [
  {'id': 'P001', 'nama': 'Sepatu Vans Second',    'penjual': 'Budi Santoso',  'kategori': 'SECOND',  'harga': 'Rp150.000', 'waktu': '2 jam lalu'},
  {'id': 'P002', 'nama': 'Mouse Logitech Reject', 'penjual': 'Sari Dewi',     'kategori': 'REJECT',  'harga': 'Rp45.000',  'waktu': '5 jam lalu'},
  {'id': 'P003', 'nama': 'Roti Sobek',            'penjual': 'Mega Putri',    'kategori': 'EXPIRED', 'harga': 'Rp5.000',   'waktu': '1 hari lalu'},
  {'id': 'P004', 'nama': 'Kaos Uniqlo',           'penjual': 'Andi Wijaya',   'kategori': 'SECOND',  'harga': 'Rp50.000',  'waktu': '1 hari lalu'},
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

  final _pages = const [
    _DashboardPage(),
    _KelolapenggunaPage(),
    _VerifikasiProdukPage(),
    _NotifikasiPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Row(
        children: [
          // ── Side Navigation ──
          _SideNav(
            selectedIndex: _selectedIndex,
            onSelect: (i) => setState(() => _selectedIndex = i),
          ),
          // ── Content ──
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
      {'icon': Icons.dashboard_outlined,    'label': 'Dashboard'},
      {'icon': Icons.people_outline,        'label': 'Pengguna'},
      {'icon': Icons.verified_outlined,     'label': 'Verifikasi'},
      {'icon': Icons.notifications_outlined,'label': 'Notifikasi'},
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
            // Logo
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD0E2F2).withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: Color(0xFFD0E2F2), size: 26),
            ),
            const SizedBox(height: 8),
            const Text('Reloved',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
            const Text('Admin Panel',
                style: TextStyle(
                    color: Color(0xFFD0E2F2), fontSize: 11)),
            const SizedBox(height: 32),
            // Nav items
            ...List.generate(items.length, (i) {
              final active = selectedIndex == i;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white.withOpacity(0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: active
                          ? Colors.white.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(items[i]['icon'] as IconData,
                          color: active
                              ? Colors.white
                              : const Color(0xFFD0E2F2).withOpacity(0.7),
                          size: 20),
                      const SizedBox(width: 10),
                      Text(
                        items[i]['label'] as String,
                        style: TextStyle(
                          color: active
                              ? Colors.white
                              : const Color(0xFFD0E2F2).withOpacity(0.7),
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            // Logout
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
                    Text('Keluar',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
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
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF3B5B8A))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar',
                style: TextStyle(color: Colors.white)),
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
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selamat Datang,',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF7a8fa6))),
                    const Text('Admin Reloved',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1a2535))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B5B8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14, color: Color(0xFF3B5B8A)),
                      SizedBox(width: 6),
                      Text('Hari ini',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF3B5B8A),
                              fontWeight: FontWeight.w600)),
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
                )),
                const SizedBox(width: 16),
                Expanded(
                    child: _StatCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Total Produk',
                  value: '24',
                  color: const Color(0xFF2e7d32),
                )),
                const SizedBox(width: 16),
                Expanded(
                    child: _StatCard(
                  icon: Icons.pending_outlined,
                  label: 'Pending Verifikasi',
                  value: '${_mockProdukPending.length}',
                  color: const Color(0xFFe65100),
                )),
                const SizedBox(width: 16),
                Expanded(
                    child: _StatCard(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Total Transaksi',
                  value: '57',
                  color: const Color(0xFF6a1b9a),
                )),
              ],
            ),
            const SizedBox(height: 28),

            // Produk pending preview
            const Text('Produk Perlu Diverifikasi',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1a2535))),
            const SizedBox(height: 12),
            ..._mockProdukPending.take(3).map((p) => _ProdukPendingTile(
                  produk: p,
                  onKonfirmasi: () {},
                  onTolak: () {},
                )),
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
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF7a8fa6))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  KELOLA PENGGUNA PAGE
// ─────────────────────────────────────────
class _KelolapenggunaPage extends StatefulWidget {
  const _KelolapenggunaPage();

  @override
  State<_KelolapenggunaPage> createState() => _KelolaPenggunaPageState();
}

class _KelolaPenggunaPageState extends State<_KelolapenggunaPage> {
  final List<Map<String, String>> _pengguna = List.from(_mockPengguna);

  void _tambahPengguna() {
    _showFormDialog(context);
  }

  void _editPengguna(int index) {
    _showFormDialog(context, pengguna: _pengguna[index], index: index);
  }

  void _hapusPengguna(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengguna',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
            'Yakin ingin menghapus "${_pengguna[index]['nama']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF3B5B8A))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _pengguna.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFormDialog(BuildContext context,
      {Map<String, String>? pengguna, int? index}) {
    final namaCtrl =
        TextEditingController(text: pengguna?['nama'] ?? '');
    final emailCtrl =
        TextEditingController(text: pengguna?['email'] ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(index == null ? 'Tambah Pengguna' : 'Edit Pengguna',
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namaCtrl,
                decoration: _formDeco('Nama Lengkap', Icons.person_outline),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailCtrl,
                decoration: _formDeco('Email', Icons.email_outlined),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Email wajib diisi' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF3B5B8A))),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  if (index == null) {
                    _pengguna.add({
                      'id': '00${_pengguna.length + 1}',
                      'nama': namaCtrl.text,
                      'email': emailCtrl.text,
                      'status': 'aktif',
                    });
                  } else {
                    _pengguna[index] = {
                      ..._pengguna[index],
                      'nama': namaCtrl.text,
                      'email': emailCtrl.text,
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B5B8A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(index == null ? 'Tambah' : 'Simpan',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration _formDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF7a8fa6), size: 20),
      filled: true,
      fillColor: const Color(0xFFf7fbff),
      labelStyle: const TextStyle(
          color: Color(0xFF3B5B8A),
          fontSize: 12,
          fontWeight: FontWeight.w600),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color(0xFFD0E2F2), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color(0xFF3B5B8A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Colors.redAccent, width: 1.5),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kelola Pengguna',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1a2535))),
                ElevatedButton.icon(
                  onPressed: _tambahPengguna,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B5B8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFf7fbff),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFD0E2F2), width: 1)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text('ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF3B5B8A)))),
                          Expanded(
                              flex: 3,
                              child: Text('Nama',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF3B5B8A)))),
                          Expanded(
                              flex: 4,
                              child: Text('Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF3B5B8A)))),
                          Expanded(
                              flex: 2,
                              child: Text('Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF3B5B8A)))),
                          Expanded(
                              flex: 2,
                              child: Text('Aksi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF3B5B8A)))),
                        ],
                      ),
                    ),
                    // Table rows
                    Expanded(
                      child: ListView.separated(
                        itemCount: _pengguna.length,
                        separatorBuilder: (_, __) => const Divider(
                            height: 1, color: Color(0xFFf0f4f8)),
                        itemBuilder: (context, i) {
                          final p = _pengguna[i];
                          final isAktif = p['status'] == 'aktif';
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(p['id']!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF7a8fa6)))),
                                Expanded(
                                    flex: 3,
                                    child: Text(p['nama']!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13))),
                                Expanded(
                                    flex: 4,
                                    child: Text(p['email']!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF7a8fa6)))),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isAktif
                                          ? const Color(0xFF2e7d32)
                                              .withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isAktif ? 'Aktif' : 'Nonaktif',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isAktif
                                            ? const Color(0xFF2e7d32)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _editPengguna(i),
                                        icon: const Icon(Icons.edit_outlined,
                                            size: 18,
                                            color: Color(0xFF3B5B8A)),
                                        tooltip: 'Edit',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        onPressed: () => _hapusPengguna(i),
                                        icon: const Icon(Icons.delete_outline,
                                            size: 18,
                                            color: Colors.redAccent),
                                        tooltip: 'Hapus',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
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
      SnackBar(
        content:
            Text('"${_produk[index]['nama']}" berhasil dikonfirmasi'),
        backgroundColor: const Color(0xFF2e7d32),
      ),
    );
    setState(() => _produk.removeAt(index));
  }

  void _tolak(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tolak Produk',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content:
            Text('Yakin ingin menolak "${_produk[index]['nama']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF3B5B8A))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _produk.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produk ditolak'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tolak',
                style: TextStyle(color: Colors.white)),
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
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1a2535))),
            const SizedBox(height: 4),
            Text('${_produk.length} produk menunggu verifikasi',
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF7a8fa6))),
            const SizedBox(height: 20),
            Expanded(
              child: _produk.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 64, color: Color(0xFF2e7d32)),
                          SizedBox(height: 12),
                          Text('Semua produk sudah diverifikasi!',
                              style: TextStyle(
                                  color: Color(0xFF7a8fa6),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _produk.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
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
      {
        'icon': Icons.new_releases_outlined,
        'color': const Color(0xFFe65100),
        'judul': 'Produk Baru Perlu Diverifikasi',
        'isi': 'Budi Santoso mengunggah "Sepatu Vans Second"',
        'waktu': '2 jam lalu',
      },
      {
        'icon': Icons.new_releases_outlined,
        'color': const Color(0xFFe65100),
        'judul': 'Produk Baru Perlu Diverifikasi',
        'isi': 'Sari Dewi mengunggah "Mouse Logitech Reject"',
        'waktu': '5 jam lalu',
      },
      {
        'icon': Icons.person_add_outlined,
        'color': const Color(0xFF3B5B8A),
        'judul': 'Pengguna Baru Terdaftar',
        'isi': 'Mega Putri baru saja mendaftar',
        'waktu': '1 hari lalu',
      },
      {
        'icon': Icons.new_releases_outlined,
        'color': const Color(0xFFe65100),
        'judul': 'Produk Baru Perlu Diverifikasi',
        'isi': 'Mega Putri mengunggah "Roti Sobek"',
        'waktu': '1 hari lalu',
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifikasi',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1a2535))),
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
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (n['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(n['icon'] as IconData,
                              color: n['color'] as Color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n['judul'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: Color(0xFF1a2535))),
                              const SizedBox(height: 2),
                              Text(n['isi'] as String,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7a8fa6))),
                            ],
                          ),
                        ),
                        Text(n['waktu'] as String,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF7a8fa6))),
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

  Color get _badgeColor {
    switch (produk['kategori']) {
      case 'SECOND':  return const Color(0xFF3B5B8A);
      case 'REJECT':  return const Color(0xFFe65100);
      case 'EXPIRED': return const Color(0xFF2e7d32);
      default:        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Placeholder gambar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFf0f4f8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image_outlined,
                color: Color(0xFF7a8fa6), size: 24),
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
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF1a2535))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(produk['kategori']!,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _badgeColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Oleh: ${produk['penjual']}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF7a8fa6))),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(produk['harga']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Color(0xFF3B5B8A))),
                    const Spacer(),
                    Text(produk['waktu']!,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF7a8fa6))),
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
                  backgroundColor: const Color(0xFF2e7d32),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(88, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Konfirmasi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: onTolak,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(88, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Tolak',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}