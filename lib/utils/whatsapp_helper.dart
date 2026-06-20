import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  /// Formats the phone number to be compatible with WhatsApp APIs.
  /// Removes non-digit characters and ensures country code 62 (for Indonesia) is applied if needed.
  static String formatPhoneNumber(String phone) {
    // Remove all non-digits (keep '+' if it's there at the start)
    var formatted = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Remove plus sign for WhatsApp API (it only needs pure numbers)
    formatted = formatted.replaceAll('+', '');
    
    // Replace leading '0' with '62' (Indonesia)
    if (formatted.startsWith('0')) {
      formatted = '62${formatted.substring(1)}';
    }
    
    // If it starts with '8', assume Indonesian number and prepend '62'
    if (formatted.startsWith('8')) {
      formatted = '62$formatted';
    }
    
    return formatted;
  }

  /// Launch WhatsApp with automated text message.
  /// Tries the custom URL scheme first (`whatsapp://`), and falls back to `https://wa.me/` if the app is missing.
  static Future<void> launchWhatsApp({
    required String phone,
    required String message,
    BuildContext? context,
  }) async {
    final formattedPhone = formatPhoneNumber(phone);
    final encodedMessage = Uri.encodeComponent(message);
    
    final appUrl = Uri.parse("whatsapp://send?phone=$formattedPhone&text=$encodedMessage");
    final webUrl = Uri.parse("https://wa.me/$formattedPhone?text=$encodedMessage");

    try {
      // Attempt launching the app directly via custom scheme
      final launched = await launchUrl(appUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Fallback to web link
        final webLaunched = await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        if (!webLaunched && context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
          );
        }
      }
    } catch (e) {
      // Fallback if the app scheme fails (e.g., ActivityNotFoundException)
      try {
        final webLaunched = await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        if (!webLaunched && context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
          );
        }
      } catch (err) {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp di browser')),
          );
        }
      }
    }
  }

  /// Launch dialer for cellular calls.
  static Future<void> makePhoneCall({
    required String phone,
    BuildContext? context,
  }) async {
    // Keep digits and '+'
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final url = Uri.parse("tel:$cleanPhone");
    
    try {
      final launched = await launchUrl(url);
      if (!launched && context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat melakukan panggilan telepon')),
        );
      }
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat melakukan panggilan telepon')),
        );
      }
    }
  }
}
