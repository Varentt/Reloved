import 'package:flutter/foundation.dart';
import 'package:reloved/services/supabase_service.dart';

class ChatRoomModel {
  final String id;
  final List<String> userIds;
  final Map<String, String> userNames;
  final String lastMessage;
  final DateTime lastMessageTime;
  final Map<String, int> unreadCount;

  ChatRoomModel({
    required this.id,
    required this.userIds,
    required this.userNames,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map, String docId) {
    // Helper to parse dynamic List to List<String>
    final rawUserIds = map['user_ids'] ?? map['userIds'];
    final List<String> parsedUserIds = rawUserIds != null 
        ? List<String>.from(rawUserIds) 
        : [];

    // Helper to parse dynamic Map to Map<String, String>
    final rawUserNames = map['user_names'] ?? map['userNames'] ?? {};
    final Map<String, String> parsedUserNames = rawUserNames is Map 
        ? rawUserNames.map((key, value) => MapEntry(key.toString(), value.toString()))
        : {};

    // Helper to parse last message time
    final rawTime = map['last_message_time'] ?? map['lastMessageTime'];
    final parsedTime = rawTime != null 
        ? DateTime.parse(rawTime.toString()).toLocal() 
        : DateTime.now();

    // Helper to parse unread count
    final rawUnread = map['unread_count'] ?? map['unreadCount'] ?? {};
    final Map<String, int> parsedUnread = rawUnread is Map 
        ? rawUnread.map((key, value) => MapEntry(key.toString(), int.tryParse(value.toString()) ?? 0))
        : {};

    return ChatRoomModel(
      id: docId,
      userIds: parsedUserIds,
      userNames: parsedUserNames,
      lastMessage: map['last_message'] ?? map['lastMessage'] ?? '',
      lastMessageTime: parsedTime,
      unreadCount: parsedUnread,
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'user_ids': userIds,
      'user_names': userNames,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toUtc().toIso8601String(),
      'unread_count': unreadCount,
    };
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    final rawTime = map['created_at'] ?? map['createdAt'];
    final parsedTime = rawTime != null 
        ? DateTime.parse(rawTime.toString()).toLocal() 
        : DateTime.now();

    return MessageModel(
      id: docId,
      senderId: map['sender_id'] ?? map['senderId'] ?? '',
      text: map['text'] ?? '',
      createdAt: parsedTime,
    );
  }

  Map<String, dynamic> toSupabaseMap(String roomId) {
    return {
      'room_id': roomId,
      'sender_id': senderId,
      'text': text,
    };
  }
}

class ChatService {
  // Mendapatkan atau membuat room chat antara 2 user
  Future<String> getOrCreateChatRoom({
    required String myId,
    required String myName,
    required String otherId,
    required String otherName,
  }) async {
    final sortedIds = [myId, otherId]..sort();
    final roomId = 'room_${sortedIds[0]}_${sortedIds[1]}';

    try {
      final existingRoom = await SupabaseService.client
          .from('chat_rooms')
          .select()
          .eq('id', roomId)
          .maybeSingle();

      if (existingRoom == null) {
        final room = ChatRoomModel(
          id: roomId,
          userIds: [myId, otherId],
          userNames: {
            myId: myName,
            otherId: otherName,
          },
          lastMessage: 'Memulai percakapan...',
          lastMessageTime: DateTime.now(),
          unreadCount: {
            myId: 0,
            otherId: 0,
          },
        );
        await SupabaseService.client.from('chat_rooms').insert(room.toSupabaseMap());
      } else {
        // Update nama terbaru jika ada perubahan
        final Map<String, String> userNames = Map<String, String>.from(
          existingRoom['user_names'] ?? existingRoom['userNames'] ?? {}
        );
        userNames[myId] = myName;
        userNames[otherId] = otherName;

        await SupabaseService.client
            .from('chat_rooms')
            .update({'user_names': userNames})
            .eq('id', roomId);
      }
    } catch (e) {
      debugPrint("Gagal dapatkan/buat chat room: $e");
    }

    return roomId;
  }

  // Kirim Pesan
  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      // 1. Simpan pesan baru ke tabel messages
      final messageData = {
        'room_id': roomId,
        'sender_id': senderId,
        'text': text.trim(),
      };
      await SupabaseService.client.from('messages').insert(messageData);

      // Cari ID penerima dari roomId (room_uid1_uid2)
      final parts = roomId.split('_');
      String otherId = '';
      if (parts.length >= 3) {
        otherId = parts[1] == senderId ? parts[2] : parts[1];
      }

      // 2. Ambil data room untuk memperbarui lastMessage & unreadCount
      final room = await SupabaseService.client
          .from('chat_rooms')
          .select()
          .eq('id', roomId)
          .maybeSingle();

      if (room != null) {
        final unreadCount = Map<String, int>.from(
          room['unread_count'] is Map 
              ? room['unread_count'] 
              : {}
        );
        
        if (otherId.isNotEmpty) {
          unreadCount[otherId] = (unreadCount[otherId] ?? 0) + 1;
        }

        await SupabaseService.client.from('chat_rooms').update({
          'last_message': text.trim(),
          'last_message_time': DateTime.now().toUtc().toIso8601String(),
          'unread_count': unreadCount,
        }).eq('id', roomId);
      }
    } catch (e) {
      debugPrint("Gagal kirim pesan: $e");
    }
  }

  // Reset unread count milik user tertentu di chat room
  Future<void> clearUnreadCount(String roomId, String uid) async {
    try {
      final room = await SupabaseService.client
          .from('chat_rooms')
          .select()
          .eq('id', roomId)
          .maybeSingle();

      if (room != null) {
        final unreadCount = Map<String, int>.from(
          room['unread_count'] is Map 
              ? room['unread_count'] 
              : {}
        );
        
        unreadCount[uid] = 0;

        await SupabaseService.client.from('chat_rooms').update({
          'unread_count': unreadCount,
        }).eq('id', roomId);
      }
    } catch (e) {
      debugPrint("Gagal mereset unreadCount: $e");
    }
  }

  // Stream pesan di dalam room chat
  Stream<List<MessageModel>> getMessages(String roomId) {
    return SupabaseService.client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .map((maps) => maps
            .map((map) => MessageModel.fromMap(map, map['id']?.toString() ?? ''))
            .toList());
  }

  // Stream daftar chat room milik user tertentu
  Stream<List<ChatRoomModel>> getUserChatRooms(String uid) {
    return SupabaseService.client
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .map((maps) {
          final List<ChatRoomModel> rooms = maps
              .map((map) => ChatRoomModel.fromMap(map, map['id']?.toString() ?? ''))
              .where((room) => room.userIds.contains(uid))
              .toList();
          
          // Urutkan berdasarkan waktu pesan terakhir secara descending
          rooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
          return rooms;
        });
  }
}
