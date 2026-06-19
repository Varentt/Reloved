import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    return ChatRoomModel(
      id: docId,
      userIds: List<String>.from(map['userIds'] ?? []),
      userNames: Map<String, String>.from(map['userNames'] ?? {}),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
      'userNames': userNames,
      'lastMessage': lastMessage,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': unreadCount,
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
    return MessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mendapatkan atau membuat room chat antara 2 user
  Future<String> getOrCreateChatRoom({
    required String myId,
    required String myName,
    required String otherId,
    required String otherName,
  }) async {
    // Generate Room ID unik dengan menggabungkan UID yang diurutkan alfabetis
    final sortedIds = [myId, otherId]..sort();
    final roomId = 'room_${sortedIds[0]}_${sortedIds[1]}';

    final roomDoc = _db.collection('chat_rooms').doc(roomId);
    final snapshot = await roomDoc.get();

    if (!snapshot.exists) {
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
      await roomDoc.set(room.toMap());
    } else {
      // Update nama terbaru jika ada perubahan
      await roomDoc.update({
        'userNames.$myId': myName,
        'userNames.$otherId': otherName,
      });
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

    final messagesRef = _db.collection('chat_rooms').doc(roomId).collection('messages');
    final roomRef = _db.collection('chat_rooms').doc(roomId);

    final batch = _db.batch();

    // 1. Simpan pesan baru
    final newMessageDoc = messagesRef.doc();
    batch.set(newMessageDoc, {
      'senderId': senderId,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Cari ID penerima dari roomId (room_uid1_uid2)
    final parts = roomId.split('_');
    String otherId = '';
    if (parts.length >= 3) {
      otherId = parts[1] == senderId ? parts[2] : parts[1];
    }

    // 2. Update parent room dengan pesan terakhir dan increment unread count penerima
    final Map<String, dynamic> updateData = {
      'lastMessage': text.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
    };
    if (otherId.isNotEmpty) {
      updateData['unreadCount.$otherId'] = FieldValue.increment(1);
    }
    batch.update(roomRef, updateData);

    await batch.commit();
  }

  // Reset unread count milik user tertentu di chat room
  Future<void> clearUnreadCount(String roomId, String uid) async {
    try {
      await _db.collection('chat_rooms').doc(roomId).update({
        'unreadCount.$uid': 0,
      });
    } catch (e) {
      debugPrint("Gagal mereset unreadCount: $e");
    }
  }

  // Stream pesan di dalam room chat
  Stream<List<MessageModel>> getMessages(String roomId) {
    return _db
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream daftar chat room milik user tertentu
  Stream<List<ChatRoomModel>> getUserChatRooms(String uid) {
    return _db
        .collection('chat_rooms')
        .where('userIds', arrayContains: uid)
        .snapshots()
        .map((snap) {
          final rooms = snap.docs
              .map((doc) => ChatRoomModel.fromMap(doc.data(), doc.id))
              .toList();
          // Urutkan berdasarkan waktu pesan terakhir menurun
          rooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
          return rooms;
        });
  }
}
