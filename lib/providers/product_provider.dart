import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _favoriteProducts = [];
  List<Product> _cartProducts = [];
  final List<Map<String, dynamic>> _orders = []; // Поле _orders теперь final
  List<Review> _reviews = [];

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
  List<Map<String, dynamic>> get orders => _orders;
  List<Product> get allProducts => _allProducts;
  List<Review> get reviews => _reviews;

  ProductProvider() {
    _loadFavorites();
    _loadCart();
    _loadReviews();
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

  Future<void> _loadReviews() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('userId', isEqualTo: user.uid)
        .get();

    _reviews =
        reviewsSnapshot.docs.map((doc) => Review.fromMap(doc.data())).toList();
    notifyListeners();
  }

  Product findProductById(int id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return Product(
        id: -1,
        name: 'Товар не найден',
        price: 0,
        description: 'Товар с id $id не найден',
        imagePath: 'assets/images/default_product.jpg',
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

  void addOrder(Map<String, dynamic> order) {
    _orders.add(order);
    notifyListeners();
  }

  Future<void> addReview(Review review) async {
    _reviews.add(review);
    await FirebaseFirestore.instance.collection('reviews').add(review.toMap());
    await _updateProductRating(
        review.productId); // Убедитесь, что этот метод вызывается
    notifyListeners();
  }

  Future<void> _updateProductRating(int productId) async {
    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();

    final reviews =
        reviewsSnapshot.docs.map((doc) => Review.fromMap(doc.data())).toList();

    final totalRating = reviews.fold(0,
        (total, review) => total + review.rating); // Переименовано sum в total
    final averageRating = totalRating / reviews.length;

    final product = _allProducts.firstWhere((p) => p.id == productId);
    product.rating = averageRating;

    notifyListeners(); // Убедитесь, что уведомление о изменении состояния отправляется
  }
}
