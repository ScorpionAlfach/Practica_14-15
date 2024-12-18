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
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Итого:'),
          Text('${totalPrice.toStringAsFixed(2)} ₽'),
        ],
      ),
    );
  }
}
