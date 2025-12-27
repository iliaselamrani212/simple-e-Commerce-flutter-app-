import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference extends ChangeNotifier {
  bool isDarkMode = false;
  String username = '';
  int cartItemCount = 0;

  Future<void> saveTheme(bool isDark) async {
    isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_dark', isDark);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('theme_dark') ?? false;
    notifyListeners();
  }
  
  Future<void> saveCartItemCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nb_atcl_panier', count);
    cartItemCount = count;
    notifyListeners();
  }

  Future<void> loadCartItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    cartItemCount = prefs.getInt('nb_atcl_panier') ?? 0;
    notifyListeners();
  }
}

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  @override
  Widget build(BuildContext context) {
    final preference = context.watch<Preference>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préférences'),
      ),
      body: ListView(
        children: [
          const Divider(),
          ListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text("Changer l'apparence"),
            leading: Switch(
              value: preference.isDarkMode,
              onChanged: (value) {
                context.read<Preference>().saveTheme(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
