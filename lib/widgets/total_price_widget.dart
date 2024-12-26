import 'package:flutter/material.dart';
import '../models/product_model.dart';

class TotalPriceWidget extends StatelessWidget {
  final List<Product> cartProducts;

  TotalPriceWidget({required this.cartProducts});

  double get totalPrice {
    return cartProducts.fold(0, (sum, product) => sum + product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Theme.of(context).cardColor, // Используем цвет карточки из темы
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Итого:',
            style: Theme.of(context)
                .textTheme
                .bodyLarge, // Используем стиль текста из темы
          ),
          Text(
            '${totalPrice.toStringAsFixed(2)} ₽',
            style: Theme.of(context)
                .textTheme
                .bodyLarge, // Используем стиль текста из темы
          ),
        ],
      ),
    );
  }
}
