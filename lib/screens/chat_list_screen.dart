import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/chat_service.dart';
import 'package:reloved/screens/chat_screen.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference == 1) {
      return 'Kemarin';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final myUser = authProvider.user;

    if (myUser == null) {
      return const Scaffold(
        backgroundColor: _surface,
        body: Center(
          child: Text('Silakan login terlebih dahulu untuk mengakses Chat'),
        ),
      );
    }

    final chatService = ChatService();

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
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
          'Pesan Chat',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: chatService.getUserChatRooms(myUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: _primary));
          }

          final rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
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
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: _primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada pesan chat',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _textPrimary),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hubungi penjual melalui halaman\ndetail produk atau pesanan!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textSecondary, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final room = rooms[index];
              
              // Temukan UID dan nama user lawan bicara
              final otherId = room.userIds.firstWhere(
                (id) => id != myUser.uid,
                orElse: () => '',
              );
              
              final otherName = room.userNames[otherId] ?? 'Pengguna Lain';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: _accent,
                    child: const Icon(Icons.person, color: _primary, size: 28),
                  ),
                  title: Text(
                    otherName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _textPrimary),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      room.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: _textSecondary),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDateTime(room.lastMessageTime),
                        style: const TextStyle(
                            fontSize: 10, color: _textSecondary),
                      ),
                      const SizedBox(height: 6),
                      if (room.unreadCount[myUser.uid] != null &&
                          room.unreadCount[myUser.uid]! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 16),
                          child: Text(
                            '${room.unreadCount[myUser.uid]}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          roomId: room.id,
                          otherId: otherId,
                          otherName: otherName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
