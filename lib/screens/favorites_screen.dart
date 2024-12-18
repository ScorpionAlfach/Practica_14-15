import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Избранное')),
      body: productProvider.favoriteProducts.isEmpty
          ? Center(child: Text('Нет избранных товаров'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: productProvider.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = productProvider.favoriteProducts[index];
                return ProductCard(
                  product: product,
                  onFavoritePressed: () {
                    productProvider.removeFromFavorites(product);
                  },
                );
              },
            ),
    );
  }
}
