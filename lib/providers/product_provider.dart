import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _favoriteProducts = [];
  List<Product> _cartProducts = [];
  List<Map<String, dynamic>> _orders = []; // Список заказов

  // Список всех товаров
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
    // Добавьте все товары
  ];

  List<Product> get favoriteProducts => _favoriteProducts;
  List<Product> get cartProducts => _cartProducts;
  List<Map<String, dynamic>> get orders => _orders; // Геттер для заказов
  List<Product> get allProducts => _allProducts; // Геттер для всех товаров

  ProductProvider() {
    _loadFavorites();
    _loadCart();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_products') ?? [];
    _favoriteProducts =
        favoriteIds.map((id) => findProductById(int.parse(id))).toList();
    notifyListeners();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartIds = prefs.getStringList('cart_products') ?? [];
    _cartProducts =
        cartIds.map((id) => findProductById(int.parse(id))).toList();
    notifyListeners();
  }

  // Публичный метод для поиска товара по id
  Product findProductById(int id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      // Если товар не найден, возвращаем заглушку
      return Product(
        id: -1,
        name: 'Товар не найден',
        price: 0,
        description: 'Товар с id $id не найден',
        imagePath:
            'assets/images/default_product.jpg', // Путь к изображению по умолчанию
      );
    }
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

  Future<void> clearCart() async {
    _cartProducts.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_products');
    notifyListeners();
  }

  // Метод для добавления заказа
  void addOrder(Map<String, dynamic> order) {
    _orders.add(order);
    notifyListeners();
  }
}
