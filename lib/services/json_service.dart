import 'dart:convert';
import 'package:flutter/services.dart';
import '../models.dart';

class JsonService {
  static Future<List<Product>> loadProducts() async {
    final String response =
    await rootBundle.loadString('images/products.json');

    final List<dynamic> data = json.decode(response);

    return data.map((e) => Product.fromJson(e)).toList();
  }
}
