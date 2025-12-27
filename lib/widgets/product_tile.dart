import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String name;
  final String imagePath;
  final String price;

  const ProductTile({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(price),
      leading: Image.asset(imagePath),
    );
  }
}
