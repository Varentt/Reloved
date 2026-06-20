import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reloved/providers/auth_provider.dart';
import 'package:reloved/services/chat_service.dart';
import 'package:reloved/models/user_model.dart';
import 'package:reloved/services/auth_service.dart';
import 'package:reloved/utils/whatsapp_helper.dart';

const _primary = Color(0xFF3B5B8A);
const _primaryDark = Color(0xFF2e4a73);
const _accent = Color(0xFFD0E2F2);
const _surface = Color(0xFFF0F4F8);
const _textPrimary = Color(0xFF1a2535);
const _textSecondary = Color(0xFF7a8fa6);

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String otherId;
  final String otherName;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.otherId,
    required this.otherName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _chatService = ChatService();
  StreamSubscription? _messageSubscription;
  UserModel? _otherUser;

  @override
  void initState() {
    super.initState();
    _clearUnread();
    _loadOtherUser();
  }

  void _loadOtherUser() async {
    final s = await AuthService().getUserData(widget.otherId);
    if (mounted) {
      setState(() {
        _otherUser = s;
      });
    }
  }

  void _clearUnread() {
    final myUser = Provider.of<AuthProvider>(context, listen: false).user;
    if (myUser != null) {
      _chatService.clearUnreadCount(widget.roomId, myUser.uid);
      
      _messageSubscription?.cancel();
      _messageSubscription = _chatService.getMessages(widget.roomId).listen((_) {
        _chatService.clearUnreadCount(widget.roomId, myUser.uid);
      });
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String myId) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await _chatService.sendMessage(
      roomId: widget.roomId,
      senderId: myId,
      text: text,
    );

    // Scroll to bottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  Future<void> _makePhoneCall(String phone) async {
    await WhatsAppHelper.makePhoneCall(phone: phone, context: context);
  }

  Future<void> _launchWhatsApp(String phone, String message) async {
    await WhatsAppHelper.launchWhatsApp(
      phone: phone,
      message: message,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final myUser = authProvider.user;

    if (myUser == null) {
      return const Scaffold(
        body: Center(child: Text('Silakan login terlebih dahulu')),
      );
    }

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
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _accent,
              child: const Icon(Icons.person, color: _primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (_otherUser?.phone != null && _otherUser!.phone!.trim().isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.phone_outlined, color: Colors.white),
              tooltip: 'Panggil',
              onPressed: () => _makePhoneCall(_otherUser!.phone!),
            ),
            IconButton(
              icon: const Icon(Icons.chat_outlined, color: Colors.white),
              tooltip: 'WhatsApp',
              onPressed: () => _launchWhatsApp(
                _otherUser!.phone!,
                "Halo ${widget.otherName}, saya menghubungi Anda melalui aplikasi Reloved.",
              ),
            ),
          ],
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatService.getMessages(widget.roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: _primary));
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chat_bubble_outline,
                              size: 40, color: _primary),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Kirim pesan untuk memulai obrolan',
                          style: TextStyle(color: _textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == myUser.uid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? _primary : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                  color: isMe ? Colors.white : _textPrimary,
                                  fontSize: 14,
                                  height: 1.4),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(msg.createdAt),
                              style: TextStyle(
                                  color: isMe ? Colors.white60 : _textSecondary,
                                  fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(fontSize: 14, color: _textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: TextStyle(color: _textSecondary, fontSize: 13),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(myUser.uid),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
