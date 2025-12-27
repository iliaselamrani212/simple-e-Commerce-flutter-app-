class Product {
  final int id;
  final String name;
  final String price;
  final String image;
  final String desc;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.desc,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      desc: json['desc'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'desc': desc,
      'category': category,
    };
  }

  double get priceValue {
    try {
      String cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Product &&
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.image == image &&
      other.desc == desc &&
      other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      image.hashCode ^
      desc.hashCode ^
      category.hashCode;
  }
}
