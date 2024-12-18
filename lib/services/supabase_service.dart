import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  Future<void> updateUserMetadata(Map<String, dynamic> metadata) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.auth.updateUser(
        UserAttributes(data: metadata),
      );
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String surname,
    required String phone,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'name': name,
        'surname': surname,
        'phone': phone,
      });
    }
  }
}
