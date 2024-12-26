import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/total_price_widget.dart';
import '../screens/my_orders_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProducts = productProvider.cartProducts;

    final totalPrice = cartProducts.fold(
        0.0, (total, product) => total + (product.price.toDouble()));

    Future<void> placeOrder(BuildContext context) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пользователь не авторизован')),
        );
        return;
      }

      bool confirmOrder = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Подтверждение заказа'),
            content: Text(
                'Вы уверены, что хотите оформить заказ на сумму $totalPrice ₽?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Оформить'),
              ),
            ],
          );
        },
      );

      if (confirmOrder != true) return;

      final order = {
        'user_id': user.uid,
        'products': cartProducts
            .map((product) => {
                  'productId': product.id,
                  'name': product.name,
                  'price': product.price,
                  'quantity': 1,
                })
            .toList(),
        'total_price': totalPrice,
        'created_at': DateTime.now().toIso8601String(),
      };

      try {
        await FirebaseFirestore.instance.collection('orders').add(order);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заказ успешно оформлен!')),
        );
        productProvider.clearCart();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Ошибка при оформлении заказа: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: Column(
        children: [
          Expanded(
            child: cartProducts.isEmpty
                ? const Center(child: Text('Корзина пуста'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return ProductCard(
                        product: product,
                        isFavorite: false,
                        isInCart: true,
                        onFavoritePressed: () {},
                        onCartPressed: () {
                          productProvider.removeFromCart(product);
                        },
                      );
                    },
                  ),
          ),
          TotalPriceWidget(cartProducts: cartProducts),
          ElevatedButton(
            onPressed: () => placeOrder(context), // Передача контекста
            child: const Text('Оформить заказ'),
          ),
        ],
      ),
    );
  }
}
