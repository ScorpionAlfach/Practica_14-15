import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _favoriteProducts = [];
  List<Product> _cartProducts = [];

  List<Product> get favoriteProducts => _favoriteProducts;
  List<Product> get cartProducts => _cartProducts;

  ProductProvider() {
    _loadFavorites();
    _loadCart();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_products') ?? [];
    _favoriteProducts =
        favoriteIds.map((id) => _findProductById(int.parse(id))).toList();
    notifyListeners();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartIds = prefs.getStringList('cart_products') ?? [];
    _cartProducts =
        cartIds.map((id) => _findProductById(int.parse(id))).toList();
    notifyListeners();
  }

  Product _findProductById(int id) {
    // Здесь нужно найти товар по id из списка всех товаров
    // Предположим, что у вас есть список всех товаров
    final allProducts = [
      Product(
          id: 1,
          name: 'Мяч',
          price: 1000,
          description:
              'Мяч баскетбольный Molten GF7X 7 размер профессиональный',
          imagePath: 'assets/images/molten_ball.webp'),
      Product(
          id: 2,
          name: 'Баскетбольный мяч FAKE',
          price: 925,
          description: 'Баскетбольные кроссовки',
          imagePath: 'assets/images/grey_ball.webp'),
      // Добавьте все товары
    ];
    return allProducts.firstWhere((product) => product.id == id);
  }

  Future<void> addToFavorites(Product product) async {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds =
          _favoriteProducts.map((p) => p.id.toString()).toList();
      await prefs.setStringList('favorite_products', favoriteIds);
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(Product product) async {
    _favoriteProducts.remove(product);
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _favoriteProducts.map((p) => p.id.toString()).toList();
    await prefs.setStringList('favorite_products', favoriteIds);
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    if (!_cartProducts.contains(product)) {
      _cartProducts.add(product);
      final prefs = await SharedPreferences.getInstance();
      final cartIds = _cartProducts.map((p) => p.id.toString()).toList();
      await prefs.setStringList('cart_products', cartIds);
      notifyListeners();
    }
  }

  Future<void> removeFromCart(Product product) async {
    _cartProducts.remove(product);
    final prefs = await SharedPreferences.getInstance();
    final cartIds = _cartProducts.map((p) => p.id.toString()).toList();
    await prefs.setStringList('cart_products', cartIds);
    notifyListeners();
  }
}
