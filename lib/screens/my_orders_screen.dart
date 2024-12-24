import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart'; // Импортируем модель товара

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orders = productProvider.orders;

    return Scaffold(
      appBar: AppBar(title: Text('Мои заказы')),
      body: orders.isEmpty
          ? Center(child: Text('У вас пока нет заказов'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final products =
                    order['products'] as List<Map<String, dynamic>>;

                // Получаем первый товар из заказа для отображения иконки
                final firstProduct = products.isNotEmpty
                    ? productProvider
                        .findProductById(products.first['productId'])
                    : null;

                return ListTile(
                  leading: firstProduct != null
                      ? Image.asset(
                          firstProduct.imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.shopping_bag), // Иконка по умолчанию
                  title: Text('Заказ №${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Итого: ${order['total_price']} ₽'),
                      Text(
                        'Время: ${_formatDateTime(order['created_at'])}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Метод для форматирования времени
  String _formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}
