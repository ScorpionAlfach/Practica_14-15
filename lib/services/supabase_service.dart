import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Методы входа и регистрации
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

  // Локальный список для хранения заказов
  final List<Map<String, dynamic>> _orders = [];

  // Метод для создания заказа
  void createOrder(
      String userId, List<Map<String, dynamic>> products, double totalPrice) {
    final order = {
      'user_id': userId,
      'products': products,
      'total_price': totalPrice,
      'created_at': DateTime.now().toIso8601String(),
    };
    _orders.add(order);
    print('Order created: $order');
  }

  // Метод для получения списка заказов
  List<Map<String, dynamic>> getOrders() {
    return _orders;
  }
}
