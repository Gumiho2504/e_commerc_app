// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {
  String? id;
  String name;
  String description;
  double price;
  String category;
  List<dynamic> colors;
  List<dynamic> size;
  bool isDiscount;
  String? discountPercentage;
  String? userId;
  String? image;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.colors,
    required this.size,
    required this.isDiscount,
    this.discountPercentage,
    this.userId,
    this.image,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'isDiscount': isDiscount,
      'discountPercentage': discountPercentage,
      'userId': userId,
    };
  }

  factory Item.fromFirestore(Map<String, dynamic> data) {
    return Item(
      id: data['id'],
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: data['price'] as double? ?? 0.0,
      isDiscount: data['isDiscount'] ?? false,
      discountPercentage: data['discountPercentage'],
      userId: data['userId'],
      category: data['category'] as String? ?? '',
      colors: data['colors'] ?? [],
      size: data['size'] ?? [],
      image: data['image'],
    );
  }

  @override
  String toString() {
    return 'Item(id: $id,name: $name, description: $description, price: $price, category: $category, colors: $colors, isDiscount: $isDiscount, discountPercentage: $discountPercentage, userId: $userId,image:$image)';
  }
}
