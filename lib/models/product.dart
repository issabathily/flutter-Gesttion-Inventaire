class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  int stock;
  final String imageUrl;
  final String details;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.details,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      imageUrl: json['imageUrl'] ?? '',
      details: json['details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'details': details,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    int? stock,
    String? imageUrl,
    String? details,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      details: details ?? this.details,
    );
  }
}
