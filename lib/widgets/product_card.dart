import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onCartPressed;

  ProductCard(
      {required this.product, this.onFavoritePressed, this.onCartPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            product.imagePath,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Text(product.name),
          Text('${product.price} ₽'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: onFavoritePressed,
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: onCartPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
