class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imagePath;
  double rating; // Добавляем рейтинг товара

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.rating = 0.0, // По умолчанию рейтинг 0
  });
}

class Review {
  final String userId;
  final int productId;
  final String review;
  final int rating;
  final DateTime timestamp;

  Review({
    required this.userId,
    required this.productId,
    required this.review,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      userId: data['userId'],
      productId: data['productId'],
      review: data['review'],
      rating: data['rating'],
      timestamp: DateTime.parse(data['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'review': review,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
