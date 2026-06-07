import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  State<PusatBantuanScreen> createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  final _searchCtrl = TextEditingController();
  int? _expandedIndex;

  final List<Map<String, String>> _faq = [
    {
      'q': 'Bagaimana cara menjual produk?',
      'a':
          'Klik tombol "Jual Produk" di navbar bawah atau beranda. Isi detail produk seperti nama, kategori, kondisi, harga, dan foto produk. Pastikan foto jelas dan deskripsi lengkap agar produkmu cepat terjual.'
    },
    {
      'q': 'Bagaimana cara melakukan pembelian?',
      'a':
          'Pilih produk yang kamu inginkan, lalu klik tombol "Beli Sekarang". Pilih metode pembayaran, konfirmasi alamat pengiriman, dan selesaikan pembayaran.'
    },
    {
      'q': 'Bagaimana jika barang tidak sesuai deskripsi?',
      'a':
          'Kamu bisa mengajukan komplain dalam 2x24 jam setelah barang diterima. Hubungi penjual terlebih dahulu, jika tidak ada solusi kamu bisa menghubungi tim Reloved melalui fitur chat bantuan.'
    },
    {
      'q': 'Metode pembayaran apa yang tersedia?',
      'a':
          'Reloved mendukung berbagai metode pembayaran: transfer bank (BCA, Mandiri, BNI, BRI), e-wallet (GoPay, OVO, Dana, ShopeePay), dan QRIS.'
    },
    {
      'q': 'Berapa lama pengiriman barang?',
      'a':
          'Penjual memiliki waktu 2x24 jam untuk mengirimkan barang setelah pembayaran dikonfirmasi. Estimasi pengiriman tergantung jasa pengiriman yang dipilih.'
    },
    {
      'q': 'Bagaimana cara mengembalikan barang?',
      'a':
          'Pengembalian barang dapat dilakukan jika kondisi barang tidak sesuai deskripsi atau ada kerusakan yang tidak tercantum. Ajukan melalui halaman detail pesanan dalam 2x24 jam setelah barang diterima.'
    },
    {
      'q': 'Apakah ada biaya untuk menjual di Reloved?',
      'a':
          'Tidak ada biaya untuk mendaftar atau memasang produk. Reloved hanya mengambil komisi kecil dari setiap transaksi yang berhasil.'
    },
  ];

  List<Map<String, String>> get _filteredFaq {
    final query = _searchCtrl.text.toLowerCase();
    if (query.isEmpty) return _faq;
    return _faq
        .where((item) =>
            item['q']!.toLowerCase().contains(query) ||
            item['a']!.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Banner ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryDark, _primary, Color(0xFF4a6fa0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.support_agent,
                        color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text('Ada yang bisa kami bantu?',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Cari jawaban dari pertanyaan yang sering diajukan',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Cari pertanyaan...',
                        hintStyle:
                            TextStyle(color: _textSecondary, fontSize: 13),
                        prefixIcon:
                            Icon(Icons.search, color: _textSecondary, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Kontak Cepat ──
                  const Text('Hubungi Kami',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: _textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _ContactCard(
                        icon: Icons.chat_bubble_outline,
                        label: 'Live Chat',
                        sub: 'Respon cepat',
                        color: Colors.green,
                        onTap: () {},
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _ContactCard(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        sub: 'bantuan@reloved.id',
                        color: _primary,
                        onTap: () {},
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _ContactCard(
                        icon: Icons.phone_outlined,
                        label: 'Telepon',
                        sub: '021-12345678',
                        color: Colors.orange,
                        onTap: () {},
                      )),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── FAQ ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pertanyaan Umum (FAQ)',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: _textPrimary)),
                      Text('${_filteredFaq.length} pertanyaan',
                          style: const TextStyle(
                              fontSize: 12, color: _textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_filteredFaq.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Pertanyaan tidak ditemukan',
                            style: TextStyle(color: _textSecondary)),
                      ),
                    )
                  else
                    ...List.generate(_filteredFaq.length, (index) {
                      final item = _filteredFaq[index];
                      final isExpanded = _expandedIndex == index;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: isExpanded
                              ? Border.all(color: _primary.withOpacity(0.3))
                              : null,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _expandedIndex = expanded ? index : null;
                              });
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.help_outline,
                                  color: _primary, size: 16),
                            ),
                            title: Text(
                              item['q']!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isExpanded ? _primary : _textPrimary),
                            ),
                            iconColor: _primary,
                            collapsedIconColor: _textSecondary,
                            childrenPadding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 16),
                            children: [
                              Text(
                                item['a']!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: _textSecondary,
                                    height: 1.6),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 24),

                  // ── Tidak Menemukan Jawaban ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.contact_support_outlined,
                            color: _primary, size: 32),
                        const SizedBox(height: 8),
                        const Text('Tidak menemukan jawaban?',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _textPrimary)),
                        const SizedBox(height: 4),
                        const Text(
                            'Tim kami siap membantu kamu 24/7',
                            style: TextStyle(
                                fontSize: 12, color: _textSecondary)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Hubungi Support',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: _textPrimary)),
            Text(sub,
                style: const TextStyle(fontSize: 9, color: _textSecondary),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}