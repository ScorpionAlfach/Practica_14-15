import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Импортируем Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Импортируем Firebase Auth
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/total_price_widget.dart';
import '../screens/my_orders_screen.dart'; // Импортируем экран "Мои заказы"

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key); // Убираем 'const'

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProducts = productProvider.cartProducts;

    // Исправляем тип totalPrice на double
    final totalPrice = cartProducts.fold(
        0.0, (sum, product) => sum + (product.price.toDouble()));

    Future<void> placeOrder() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пользователь не авторизован')),
        );
        return;
      }

      // Создаем заказ
      final order = {
        'user_id': user.uid, // ID пользователя
        'products': cartProducts
            .map((product) => {
                  'productId': product.id,
                  'name': product.name,
                  'price': product.price,
                  'quantity': 1,
                })
            .toList(),
        'total_price': totalPrice,
        'created_at':
            DateTime.now().toIso8601String(), // Добавляем время создания заказа
      };

      // Сохраняем заказ в Firestore
      try {
        await FirebaseFirestore.instance.collection('orders').add(order);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Заказ успешно оформлен!')),
        );
        productProvider.clearCart(); // Очищаем корзину после оформления заказа

        // Переходим на экран "Мои заказы"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Ошибка при оформлении заказа: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Корзина')),
      body: Column(
        children: [
          Expanded(
            child: cartProducts.isEmpty
                ? Center(child: Text('Корзина пуста'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return ProductCard(
                        product: product,
                        onCartPressed: () {
                          productProvider.removeFromCart(product);
                        },
                      );
                    },
                  ),
          ),
          TotalPriceWidget(cartProducts: cartProducts),
          ElevatedButton(
            onPressed: placeOrder,
            child: Text('Оформить заказ'),
          ),
        ],
      ),
    );
  }
}
