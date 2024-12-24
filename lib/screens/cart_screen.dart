import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      // Локальное создание заказа
      final order = {
        'user_id': 'local_user_id', // Заглушка для user_id
        'products': cartProducts
            .map((product) => {'productId': product.id, 'quantity': 1})
            .toList(),
        'total_price': totalPrice,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Добавляем заказ в ProductProvider
      productProvider.addOrder(order);

      if (context.mounted) {
        // Проверка на доступность контекста
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Заказ успешно оформлен!')),
        );
        productProvider.clearCart(); // Очищаем корзину после оформления заказа

        // Переходим на экран "Мои заказы"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersScreen()),
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
