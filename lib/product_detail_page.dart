import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/etat.dart';
import 'package:app/panier.dart';
import 'package:app/profile_page.dart';
import 'package:app/models.dart';
import 'package:app/history_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryState>().addAction("Consulté : ${widget.product.name}");
    });
  }

  @override
  Widget build(BuildContext context) {
    bool added = context.watch<Panier_etat>().panier.any((item) => item.id == widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartShop'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Panier()),
            ),
            icon: const Icon(Icons.shopping_basket),
          ),
          Center(child: Text('${context.watch<Panier_etat>().num_items}')),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(widget.product.image, height: 150)),
            const SizedBox(height: 20),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Icon(Icons.star, color: Colors.amber),
                Icon(Icons.star, color: Colors.amber),
                Icon(Icons.star, color: Colors.amber),
                Icon(Icons.star_border),
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.product.price, style: const TextStyle(color: Colors.teal, fontSize: 18)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: added ? Colors.grey : Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(added ? 'Supprimer du panier' : 'Ajouter au panier'),
                        content: Text(added ? 'Voulez-vous retirer ce produit ?' : 'Voulez-vous ajouter ce produit ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              final panier = context.read<Panier_etat>();
                              final history = context.read<HistoryState>();
                              
                              if (added) {
                                panier.supprimer(widget.product);
                                history.addAction("Retiré du panier : ${widget.product.name}");
                              } else {
                                panier.ajouter(widget.product);
                                history.addAction("Ajouté au panier : ${widget.product.name}");
                              }
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(added ? 'Produit retiré du panier' : 'Produit ajouté au panier')),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Annuler'),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  added ? 'Retirer du panier' : 'Ajouter au panier',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
