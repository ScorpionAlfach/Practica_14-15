import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Импортируем экран входа для перехода после выхода
import '../screens/my_orders_screen.dart'; // Импортируем экран "Мои заказы"
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.displayName ?? '';
        _surnameController.text = ''; // Добавьте логику для фамилии, если нужно
        _emailController.text = user.email ?? '';
        _phoneController.text = ''; // Добавьте логику для телефона, если нужно
      });
    }
  }

  Future<void> _loadOrders() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final orders = productProvider.orders;
    setState(() {
      _orders = orders;
    });
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Поле "Имя" не может быть пустым')),
        );
        return;
      }

      await user.updateDisplayName(_nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Профиль обновлен')),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
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
          ElevatedButton(
            onPressed: _updateProfile,
            child: Text('Изменить'),
          ),
          SizedBox(height: 20),
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
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          ..._orders
              .map((order) => ListTile(
                    title: Text('Заказ №${_orders.indexOf(order) + 1}'),
                    subtitle: Text('Итого: ${order['total_price']} ₽'),
                    trailing: Text('${order['created_at']}'),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
