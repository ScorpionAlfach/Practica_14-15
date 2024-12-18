import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/total_price_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Корзина')),
      body: Column(
        children: [
          Expanded(
            child: productProvider.cartProducts.isEmpty
                ? Center(child: Text('Корзина пуста'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: productProvider.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.cartProducts[index];
                      return ProductCard(
                        product: product,
                        onCartPressed: () {
                          productProvider.removeFromCart(product);
                        },
                      );
                    },
                  ),
          ),
          TotalPriceWidget(cartProducts: productProvider.cartProducts),
        ],
      ),
    );
  }
}
