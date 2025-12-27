import 'package:flutter/material.dart';
import 'package:app/models.dart';

class Panier_etat extends ChangeNotifier {
  List<Product> panier = [];
  
  int get num_items => panier.length;
  
  double get somme => panier.fold(0.0, (total, current) => total + current.priceValue);

  void ajouter(Product item) {
    panier.add(item);
    notifyListeners();
  }

  void supprimer(Product item) {
    panier.remove(item);
    notifyListeners();
  }
}
