import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://pwtgfygvnfmhzuikajhg.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_YIcGd21a0PYe11ArLZOPCg_Gr8sCDFr';
  
  // Catatan Kredensial Database Supabase Reloved:
  // URL Proyek: https://pwtgfygvnfmhzuikajhg.supabase.co
  // REST URL: https://pwtgfygvnfmhzuikajhg.supabase.co/rest/v1/
  // Password Database: SNLbG4LYZmIr0d6D (Untuk koneksi PostgreSQL langsung / migrations)

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
