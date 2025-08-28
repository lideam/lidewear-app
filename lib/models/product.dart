class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final DateTime createdAt;
  bool isFavorite;
  final double rating;
  final List<String> reviews;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
    this.isFavorite = false,
    this.rating = 0.0,
    this.reviews = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isFavorite: json['isFavorite'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  // ✅ Add this
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
  }
}
