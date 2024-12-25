import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'seller_chats_screen.dart';
import 'chat_screen.dart';
import '../screens/my_orders_screen.dart';
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
        _surnameController.text = '';
        _emailController.text = user.email ?? '';
        _phoneController.text = '';
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

  Future<String> _getOrCreateChatId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Пользователь не авторизован');

    final sellerEmail = 'email@gmail.com'; // Email продавца
    final sellerQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: sellerEmail)
        .get();

    if (sellerQuery.docs.isEmpty) throw Exception('Продавец не найден');

    final sellerId = sellerQuery.docs.first.id;
    final clientId = user.uid;

    // Поиск существующего чата
    final chatQuery = await FirebaseFirestore.instance
        .collection('chats')
        .where('clientId', isEqualTo: clientId)
        .where('sellerId', isEqualTo: sellerId)
        .get();

    if (chatQuery.docs.isNotEmpty) {
      return chatQuery.docs.first.id; // Возвращаем ID существующего чата
    }

    // Создание нового чата
    final chatRef = await FirebaseFirestore.instance.collection('chats').add({
      'clientId': clientId,
      'sellerId': sellerId,
      'lastMessage': 'Чат начат', // Добавляем поле lastMessage
      'lastMessageTime': DateTime.now(),
    });

    return chatRef.id; // Возвращаем ID нового чата
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isSeller = user?.email == 'email@gmail.com';

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
            onPressed: () async {
              if (isSeller) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellerChatsScreen()),
                );
              } else {
                try {
                  final chatId = await _getOrCreateChatId();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chatId),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${e.toString()}')),
                  );
                }
              }
            },
            child: Text(isSeller ? 'Мои чаты' : 'Чат с продавцом'),
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
