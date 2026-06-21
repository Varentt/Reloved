import 'package:flutter/foundation.dart';
import 'package:reloved/services/supabase_service.dart';

class NotificationService {
  // 1. Send notification (insert into Supabase)
  Future<String?> sendNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await SupabaseService.client.from('notifications').insert({
        'user_id': userId,
        'type': type,
        'title': title,
        'body': body,
        'is_read': false,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'data': data,
      });
      return null; // Success
    } catch (e) {
      debugPrint("Error sending notification: $e");
      return e.toString();
    }
  }

  // 2. Stream notifications for a specific user (realtime)
  Stream<List<Map<String, dynamic>>> streamNotifications(String userId) {
    return SupabaseService.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((maps) {
          final list = List<Map<String, dynamic>>.from(maps);
          list.sort((a, b) {
            final ta = DateTime.tryParse(a['created_at']?.toString() ?? '') ?? DateTime.now();
            final tb = DateTime.tryParse(b['created_at']?.toString() ?? '') ?? DateTime.now();
            return tb.compareTo(ta);
          });
          return list;
        });
  }

  // 3. Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    try {
      await SupabaseService.client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId);
    } catch (e) {
      debugPrint("Error marking all read: $e");
    }
  }

  // 4. Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await SupabaseService.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      debugPrint("Error marking read: $e");
    }
  }
}
