import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/etat.dart';
import 'package:app/profile_page.dart';
import 'package:app/models.dart';
import 'package:app/history_page.dart';

class Panier extends StatelessWidget {
  const Panier({super.key});

  @override
  Widget build(BuildContext context) {
    final panierEtat = context.watch<Panier_etat>();
    final panierList = panierEtat.panier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartShop'),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.shopping_basket),
          ),
          Center(child: Text('${panierEtat.num_items}')),
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
        padding: const EdgeInsets.all(12),
        child: panierList.isEmpty
            ? const Center(child: Text('Le panier est vide'))
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: panierList.length,
                      itemBuilder: (context, index) {
                        final Product p = panierList[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(p.image, height: 80),
                              const SizedBox(height: 8),
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                p.price,
                                style: const TextStyle(color: Colors.teal),
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Vous êtes sûr ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<Panier_etat>().supprimer(p);
                                              context.read<HistoryState>().addAction("Retiré du panier : ${p.name}");
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Retirer'),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'Somme totale à payer : ${panierEtat.somme.toStringAsFixed(2)} DH',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
