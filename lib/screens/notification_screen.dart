import 'package:flutter/material.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifs = [
    {
      'type': 'order',
      'icon': Icons.local_shipping_outlined,
      'color': Colors.blue,
      'title': 'Pesanan Sedang Dikirim',
      'body': 'Kemeja Flanel Uniqlo kamu sedang dalam perjalanan.',
      'time': '2 jam lalu',
      'read': false,
    },
    {
      'type': 'order',
      'icon': Icons.check_circle_outline,
      'color': Color(0xFF2e7d32),
      'title': 'Pesanan Selesai',
      'body': 'Buku Harry Potter telah dikonfirmasi selesai. Terima kasih!',
      'time': '1 hari lalu',
      'read': false,
    },
    {
      'type': 'sell',
      'icon': Icons.shopping_bag_outlined,
      'color': _primary,
      'title': 'Produk Kamu Dipesan!',
      'body': 'Kamera Analog Canon kamu dipesan oleh Budi S. Segera kirim barang.',
      'time': '1 hari lalu',
      'read': true,
    },
    {
      'type': 'sell',
      'icon': Icons.verified_outlined,
      'color': Color(0xFF2e7d32),
      'title': 'Produk Disetujui Admin',
      'body': 'Sepatu Vans Second kamu telah diverifikasi dan kini tampil di marketplace.',
      'time': '2 hari lalu',
      'read': true,
    },
    {
      'type': 'promo',
      'icon': Icons.local_offer_outlined,
      'color': Color(0xFFe65100),
      'title': 'Promo Spesial Hari Ini!',
      'body': 'Diskon ekstra untuk produk kategori Reject. Cek sekarang!',
      'time': '3 hari lalu',
      'read': true,
    },
    {
      'type': 'expiry',
      'icon': Icons.fastfood_outlined,
      'color': Colors.orange,
      'title': 'Produkmu Hampir Expired',
      'body': 'Roti Sobek yang kamu jual akan expired dalam 2 hari. Turunkan harga agar cepat terjual.',
      'time': '3 hari lalu',
      'read': true,
    },
  ];

  int get _unreadCount => _notifs.where((n) => n['read'] == false).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifs) {
        n['read'] = true;
      }
    });
  }

  void _markRead(int index) {
    setState(() => _notifs[index]['read'] = true);
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
        title: const Text('Notifikasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Tandai semua dibaca',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
        ],
      ),
      body: _notifs.isEmpty
          ? _EmptyNotif()
          : Column(
              children: [
                if (_unreadCount > 0)
                  Container(
                    width: double.infinity,
                    color: _accent.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('$_unreadCount notifikasi belum dibaca',
                        style: const TextStyle(fontSize: 12, color: _primary, fontWeight: FontWeight.w600)),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final n = _notifs[i];
                      final isRead = n['read'] as bool;
                      return GestureDetector(
                        onTap: () => _markRead(i),
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
                                  color: (n['color'] as Color).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(n['icon'] as IconData,
                                    color: n['color'] as Color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(n['title'] as String,
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
                                    Text(n['body'] as String,
                                        style: const TextStyle(
                                            fontSize: 12, color: _textSecondary, height: 1.4)),
                                    const SizedBox(height: 6),
                                    Text(n['time'] as String,
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
  }
}

class _EmptyNotif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.notifications_none_outlined, size: 48, color: _primary),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada notifikasi',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _textPrimary)),
          const SizedBox(height: 6),
          const Text('Notifikasi pesanan dan aktivitas\nakunmu akan muncul di sini',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}