import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/notification_service.dart';
import 'package:reloved/services/order_service.dart';
import 'package:reloved/screens/order_detail_screen.dart';

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
  final Set<String> _readNotifIds = {};
  bool _allMarkedRead = false;

  IconData _getIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.local_shipping_outlined;
      case 'approve_product':
        return Icons.verified_outlined;
      case 'reject_product':
        return Icons.gpp_bad_outlined;
      case 'promo':
        return Icons.local_offer_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'approve_product':
        return Colors.green;
      case 'reject_product':
        return Colors.red;
      case 'promo':
        return Colors.orange;
      default:
        return _primary;
    }
  }

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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        backgroundColor: _surface,
        body: Center(child: Text('Silakan login terlebih dahulu')),
      );
    }

    final notificationService = NotificationService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: notificationService.streamNotifications(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: _surface,
            appBar: AppBar(
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
              title: const Text(
                'Notifikasi',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
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
            title: const Text(
              'Notifikasi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              if (unreadCount > 0)
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _allMarkedRead = true;
                    });
                    try {
                      await notificationService.markAllAsRead(user.uid);
                    } catch (_) {
                      if (mounted) {
                        setState(() {
                          _allMarkedRead = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Tandai semua dibaca',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
            ],
          ),
          body: notifs.isEmpty
              ? _EmptyNotif()
              : Column(
                  children: [
                    if (unreadCount > 0)
                      Container(
                        width: double.infinity,
                        color: _accent.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          '$unreadCount notifikasi belum dibaca',
                          style: const TextStyle(
                            fontSize: 12,
                            color: _primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final n = notifs[i];
                          final id = n['id']?.toString() ?? '';
                          final isRead = n['is_read'] as bool;
                          final type = n['type']?.toString() ?? '';
                          final createdAt = n['created_at']?.toString() ?? '';

                          return GestureDetector(
                            onTap: () async {
                              if (!isRead) {
                                setState(() {
                                  _readNotifIds.add(id);
                                });
                                await notificationService.markAsRead(id);
                              }

                              // Cek payload data untuk navigasi pesanan
                              final payload = n['data'];
                              if (payload is Map && payload.containsKey('orderId')) {
                                final orderId = payload['orderId']?.toString();
                                if (orderId != null && orderId.isNotEmpty) {
                                  // Tampilkan loading dialog
                                  if (!context.mounted) return;
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(child: CircularProgressIndicator(color: _primary)),
                                  );

                                  final order = await OrderService().getOrderById(orderId);
                                  
                                  if (context.mounted) {
                                    Navigator.pop(context); // Tutup loading dialog
                                  }

                                  if (order != null && context.mounted) {
                                    final roleType = order.buyerId == user.uid ? 'pembelian' : 'penjualan';
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OrderDetailScreen(order: order, type: roleType),
                                      ),
                                    );
                                  }
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
                                      color: _getColor(type).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getIcon(type),
                                      color: _getColor(type),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                n['title']?.toString() ?? '',
                                                style: TextStyle(
                                                  fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                                                  fontSize: 13,
                                                  color: _textPrimary,
                                                ),
                                              ),
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
                                        Text(
                                          n['body']?.toString() ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: _textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _getRelativeTime(createdAt),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: _textSecondary,
                                          ),
                                        ),
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
            child: const Icon(
              Icons.notifications_none_outlined,
              size: 48,
              color: _primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Notifikasi pesanan dan aktivitas\nakunmu akan muncul di sini',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
