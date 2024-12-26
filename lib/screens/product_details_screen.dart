import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'review_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isFavorite = productProvider.favoriteProducts.contains(product);
    final isInCart = productProvider.cartProducts.contains(product);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              product.imagePath,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product.price} ₽', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text(product.description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Рейтинг: ${product.rating.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (isFavorite) {
                            productProvider.removeFromFavorites(product);
                          } else {
                            productProvider.addToFavorites(product);
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        label: Text(isFavorite ? 'Удалить' : 'В избранное'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (isInCart) {
                            productProvider.removeFromCart(product);
                          } else {
                            productProvider.addToCart(product);
                          }
                        },
                        icon: Icon(
                          isInCart
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart,
                          color: isInCart ? Colors.blue : Colors.grey,
                        ),
                        label: Text(isInCart ? 'Удалить' : 'В корзину'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(product: product),
                    ),
                  );
                },
                child: Text('Оставить отзыв'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
