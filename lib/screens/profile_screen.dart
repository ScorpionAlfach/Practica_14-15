import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart'; // Импортируем экран входа для перехода после выхода
import '../screens/my_orders_screen.dart'; // Импортируем экран "Мои заказы"

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabaseService = SupabaseService();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadOrders();
  }

  Future<void> _loadProfileData() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      setState(() {
        _nameController.text = user.userMetadata?['name'] ?? '';
        _surnameController.text = user.userMetadata?['surname'] ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.userMetadata?['phone'] ?? '';
      });
    }
  }

  Future<void> _loadOrders() async {
    final orders = _supabaseService.getOrders();
    setState(() {
      _orders = orders;
    });
  }

  Future<void> _updateProfile() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      await _supabaseService.updateUserMetadata({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'phone': _phoneController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Профиль обновлен')),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await _supabaseService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выхода: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поля для редактирования профиля
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Фамилия'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Электронная почта'),
              enabled: false,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Телефон'),
            ),
            SizedBox(height: 20),

            // Кнопка для обновления профиля
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Изменить'),
            ),
            SizedBox(height: 20),

            // Кнопка для выхода

            // Кнопка для перехода на страницу "Мои заказы"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrdersScreen()),
                );
              },
              child: Text('Мои заказы'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Выйти'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Используем backgroundColor вместо primary
              ),
            ),
            SizedBox(height: 20),
            // Список заказов
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return ListTile(
                    title: Text('Заказ №${index + 1}'),
                    subtitle: Text('Итого: ${order['total_price']} ₽'),
                    trailing: Text('${order['created_at']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
