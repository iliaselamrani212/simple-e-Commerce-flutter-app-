import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models.dart';
import 'package:app/services/json_service.dart';
import 'package:app/product_detail_page.dart';
import 'package:app/history_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> allProducts = [];
  List<Product> filteredList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await JsonService.loadProducts();
    setState(() {
      allProducts = products;
      filteredList = products;
      isLoading = false;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = allProducts;
      } else {
        filteredList = allProducts
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rechercher un produit"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Nom du produit...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterProducts(value);
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                   context.read<HistoryState>().addAction("Recherche : $value");
                }
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                    ? const Center(child: Text("Aucun produit trouvé"))
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final product = filteredList[index];
                          return ListTile(
                            leading: Image.asset(product.image, width: 40),
                            title: Text(product.name),
                            subtitle: Text(product.price),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
