import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';
  String _sortBy = 'name'; // По умолчанию сортировка по имени

  final List<Product> _allProducts = [
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

  List<Product> get filteredProducts {
    var result = _allProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortBy == 'price') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'name') {
      result.sort((a, b) => a.name.compareTo(b.name));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Каталог'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _showSortDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Поиск',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                            product: filteredProducts[index]),
                      ),
                    );
                  },
                  child: ProductCard(product: filteredProducts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Сортировка'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('По цене'),
                tileColor: _sortBy == 'price'
                    ? Colors.grey[200]
                    : null, // Подсветка серым
                onTap: () {
                  setState(() {
                    _sortBy = 'price';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('По имени'),
                tileColor: _sortBy == 'name'
                    ? Colors.grey[200]
                    : null, // Подсветка серым
                onTap: () {
                  setState(() {
                    _sortBy = 'name';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
