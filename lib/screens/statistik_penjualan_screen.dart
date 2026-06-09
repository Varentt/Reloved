import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class StatistikPenjualanScreen extends StatefulWidget {
  const StatistikPenjualanScreen({super.key});

  @override
  State<StatistikPenjualanScreen> createState() =>
      _StatistikPenjualanScreenState();
}

class _StatistikPenjualanScreenState extends State<StatistikPenjualanScreen> {
  final List<Map<String, dynamic>> _bulananData = const [
    {'bulan': 'Jan', 'pendapatan': 250000},
    {'bulan': 'Feb', 'pendapatan': 400000},
    {'bulan': 'Mar', 'pendapatan': 320000},
    {'bulan': 'Apr', 'pendapatan': 580000},
    {'bulan': 'Mei', 'pendapatan': 470000},
    {'bulan': 'Jun', 'pendapatan': 620000},
    {'bulan': 'Jul', 'pendapatan': 390000},
    {'bulan': 'Agu', 'pendapatan': 510000},
    {'bulan': 'Sep', 'pendapatan': 445000},
    {'bulan': 'Okt', 'pendapatan': 680000},
    {'bulan': 'Nov', 'pendapatan': 720000},
    {'bulan': 'Des', 'pendapatan': 850000},
  ];

  final List<Map<String, dynamic>> _produkTerjual = const [
    {'nama': 'Jaket Denim Oversized', 'tanggal': '03 Jun 2025', 'harga': 175000, 'pembeli': 'Ahmad S.'},
    {'nama': 'Dress Floral Vintage', 'tanggal': '20 Mei 2025', 'harga': 95000, 'pembeli': 'Sari W.'},
    {'nama': 'Kemeja Flannel Vintage', 'tanggal': '15 Mei 2025', 'harga': 85000, 'pembeli': 'Budi P.'},
    {'nama': 'Celana Chino Slim', 'tanggal': '10 Mei 2025', 'harga': 90000, 'pembeli': 'Dewi R.'},
    {'nama': 'Tas Tote Kanvas', 'tanggal': '02 Mei 2025', 'harga': 65000, 'pembeli': 'Rina M.'},
  ];

  int? _hoveredIndex;

  String _formatRupiah(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}jt';
    return '${(amount / 1000).toStringAsFixed(0)}rb';
  }

  String _formatRupiahFull(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  int get _totalPendapatan =>
      _bulananData.fold(0, (sum, e) => sum + (e['pendapatan'] as int));

  @override
  Widget build(BuildContext context) {
    final maxPendapatan = _bulananData
        .map((e) => e['pendapatan'] as int)
        .reduce((a, b) => a > b ? a : b);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Statistik Penjualan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ringkasan (tanpa Pesanan Selesai) ──
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Pendapatan',
                    value: 'Rp ${_formatRupiah(_totalPendapatan)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Produk Terjual',
                    value: '${_produkTerjual.length}',
                    icon: Icons.inventory_2_outlined,
                    color: _primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Grafik ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pendapatan Per Bulan',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: _textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Seluruh bulan dalam setahun',
                      style: TextStyle(fontSize: 11, color: _textSecondary)),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: _bulananData.length * 52.0,
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_bulananData.length, (index) {
                          final data = _bulananData[index];
                          final persen = (data['pendapatan'] as int) / maxPendapatan;
                          final isHovered = _hoveredIndex == index;

                          return GestureDetector(
                            onTap: () => setState(() {
                              _hoveredIndex = _hoveredIndex == index ? null : index;
                            }),
                            child: SizedBox(
                              width: 52,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: isHovered ? 1.0 : 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(6)),
                                      child: Text(_formatRupiah(data['pendapatan'] as int),
                                          style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (!isHovered)
                                    Text(_formatRupiah(data['pendapatan'] as int),
                                        style: const TextStyle(fontSize: 7, color: _textSecondary, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      height: 100 * persen,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isHovered
                                              ? [const Color(0xFF4a6fa0), _primaryDark]
                                              : [_primary.withOpacity(0.6), _primary],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(data['bulan'],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: isHovered ? _primary : _textSecondary,
                                          fontWeight: isHovered ? FontWeight.w800 : FontWeight.w600)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text('Ketuk bar untuk lihat detail',
                        style: TextStyle(fontSize: 10, color: _textSecondary)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Produk Terjual ──
            const Text('Produk Terjual',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: _textPrimary)),
            const SizedBox(height: 12),
            ...List.generate(_produkTerjual.length, (index) {
              final item = _produkTerjual[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
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
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.checkroom, color: _primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['nama'],
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _textPrimary)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 12, color: _textSecondary),
                              const SizedBox(width: 3),
                              Text(item['pembeli'],
                                  style: const TextStyle(fontSize: 11, color: _textSecondary)),
                              const SizedBox(width: 10),
                              const Icon(Icons.calendar_today_outlined, size: 11, color: _textSecondary),
                              const SizedBox(width: 3),
                              Text(item['tanggal'],
                                  style: const TextStyle(fontSize: 11, color: _textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rp ${_formatRupiahFull(item['harga'] as int)}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _primary)),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Terjual',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _primary)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: _textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: _textSecondary)),
        ],
      ),
    );
  }
}