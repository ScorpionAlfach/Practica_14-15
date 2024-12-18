import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class CatalogScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
        id: 1,
        name: 'Мяч',
        price: 1000,
        description: 'Мяч баскетбольный Molten GF7X 7 размер профессиональный',
        imagePath: 'assets/images/molten_ball.webp'),
    Product(
        id: 2,
        name: 'Баскетбольный мяч FAKE',
        price: 925,
        description: 'Баскетбольные кроссовки',
        imagePath: 'assets/images/grey_ball.webp'),
    Product(
        id: 3,
        name: 'Баскетбольный мяч',
        price: 2152,
        description: 'Баскетбольный мяч',
        imagePath: 'assets/images/purple_ball.webp'),
    Product(
        id: 4,
        name: 'Баскетбольный мяч светоотражающий',
        price: 1801,
        description:
            'Баскетбольный мяч светоотражающий 7 размер для улицы и зала',
        imagePath: 'assets/images/light_ball.webp'),
    Product(
        id: 5,
        name: 'Баскетбольный мяч Challenger размер 7',
        price: 1399,
        description: 'Баскетбольный мяч Challenger размер 7',
        imagePath: 'assets/images/jogel_ball.webp'),
    Product(
        id: 6,
        name: 'palding мяч баскетбольный',
        price: 1674,
        description: 'Баскетбольный мяч 7 размер для улицы и зала',
        imagePath: 'assets/images/spalding_ball.webp'),
    Product(
        id: 7,
        name: 'ECOBALL Replica размер 7',
        price: 1999,
        description:
            'Баскетбольный мяч профессиональный ECOBALL Replica размер 7',
        imagePath: 'assets/images/VTB_ball.webp'),
    Product(
        id: 8,
        name: 'Детская джерси',
        price: 912,
        description: 'Баскетбольная форма детская Brooklyn Durant"',
        imagePath: 'assets/images/Jersey_brooklyn.webp'),
    Product(
        id: 9,
        name: 'Баскетбольный мяч 7',
        price: 1568,
        description: 'KGUMIHO баскетбольный мяч',
        imagePath: 'assets/images/braun_ball.webp'),
    Product(
        id: 10,
        name: 'Баскетбольный мяч 7 размер для улицы и зала',
        price: 1653,
        description: 'Баскетбольный мяч резина 7 размер для улицы и зала',
        imagePath: 'assets/images/blue_ball.webp'),
    Product(
        id: 11,
        name: 'City-ride',
        price: 775,
        description: 'Баскетбольные кроссовки',
        imagePath: 'assets/images/orange_ball.webp'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Каталог')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsScreen(product: products[index]),
                ),
              );
            },
            child: ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}
