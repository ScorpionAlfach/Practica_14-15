import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key}); // Добавлен параметр key

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: productProvider.favoriteProducts.isEmpty
          ? const Center(child: Text('Нет избранных товаров'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: productProvider.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = productProvider.favoriteProducts[index];
                return ProductCard(
                  product: product,
                  isFavorite: true,
                  isInCart: productProvider.cartProducts.contains(product),
                  onFavoritePressed: () {
                    productProvider.removeFromFavorites(product);
                  },
                  onCartPressed: () {
                    if (productProvider.cartProducts.contains(product)) {
                      productProvider.removeFromCart(product);
                    } else {
                      productProvider.addToCart(product);
                    }
                  },
                );
              },
            ),
    );
  }
}
