import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/json_service.dart';
import '../services/db_service.dart';

import '../etat.dart';
import '../panier.dart';
import '../product_detail_page.dart';
import '../profile_page.dart';
import '../searchPage.dart';
import '../history_page.dart';
import 'favorites_page.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryIndex = -1;

  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  List<int> favoriteIds = [];

  bool isLoading = true;

  final List<String> categories = [
    'all',
    'phones',
    'laptops',
    'watch',
    'gaming',
    'accessoires'
  ];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await JsonService.loadProducts();
    setState(() {
      allProducts = products;
      displayedProducts = products;
      isLoading = false;
    });
  }

  Future<void> loadFavorites() async {
    final data = await DBService.getFavorites();
    setState(() {
      favoriteIds = data.map((e) => e['id'] as int).toList();
    });
  }

  void filterByCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
      if (index == 0) {
        displayedProducts = allProducts;
      } else {
        displayedProducts = allProducts
            .where((p) => p.category == categories[index])
            .toList();
      }
    });
  }

  Future<void> toggleFavorite(Product product) async {
    if (favoriteIds.contains(product.id)) {
      await DBService.deleteFavorite(product.id);
      setState(() => favoriteIds.remove(product.id));
    } else {
      await DBService.insertFavorite({
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'imagePath': product.image,
      });
      setState(() => favoriteIds.add(product.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartShop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Panier()),
              );
            },
          ),
          Center(child: Text('${context.watch<Panier_etat>().num_items}')),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              ).then((_) => loadFavorites());
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final selected = selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => filterByCategory(selected ? -1 : index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? Colors.green : Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categories[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : displayedProducts.isEmpty
                      ? const Center(child: Text('Aucun produit trouvé'))
                      : GridView.builder(
                          itemCount: displayedProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final product = displayedProducts[index];
                            final isFavorite = favoriteIds.contains(product.id);
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(product.image, height: 80),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    product.price,
                                    style: const TextStyle(color: Colors.teal),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        child: const Text('Details'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ProductDetailPage(
                                                product: product,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => toggleFavorite(product),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
