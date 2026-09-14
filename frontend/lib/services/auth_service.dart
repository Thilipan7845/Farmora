import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_client.dart';

class AuthService {
  static final SupabaseClient supabase =
      Supabase.instance.client;

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<void> login(
    String email,
    String password,
  ) async {
    final AuthResponse response =
        await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final Session? session = response.session;

    if (session == null) {
      throw Exception("Login failed");
    }

    // Store Supabase JWT
    ApiClient.accessToken = session.accessToken;
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  static Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await ApiClient.get(
      "/api/auth/me",
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception("Invalid user response");
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static Future<void> logout() async {
    await supabase.auth.signOut();

    ApiClient.accessToken = null;
  }
}