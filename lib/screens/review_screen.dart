import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewScreen extends StatefulWidget {
  final Product product;

  const ReviewScreen(
      {super.key, required this.product}); // Добавлен параметр key и const

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _reviewController = TextEditingController();
  int _rating = 0;

  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return; // Проверка mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь не авторизован')),
      );
      return;
    }

    if (_reviewController.text.isEmpty || _rating == 0) {
      if (!mounted) return; // Проверка mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Пожалуйста, заполните отзыв и поставьте оценку')),
      );
      return;
    }

    final review = Review(
      userId: user.uid,
      productId: widget.product.id,
      review: _reviewController.text,
      rating: _rating,
      timestamp: DateTime.now(),
    );

    try {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.addReview(review);

      if (!mounted) return; // Проверка mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Отзыв успешно добавлен')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return; // Проверка mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении отзыва: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оставить отзыв')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(labelText: 'Ваш отзыв'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}
