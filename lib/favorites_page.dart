import 'package:flutter/material.dart';
import '../services/db_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await DBService.getFavorites();
    setState(() => favorites = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Favoris')),
      body: favorites.isEmpty
          ? const Center(child: Text('Aucun favori'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final fav = favorites[index];
          return ListTile(
            leading: Image.asset(
              fav['imagePath'],
              width: 50,
            ),
            title: Text(fav['name']),
            subtitle: Text(fav['price']),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await DBService.deleteFavorite(fav['id']);
                loadFavorites();
              },
            ),
          );
        },
      ),
    );
  }
}
