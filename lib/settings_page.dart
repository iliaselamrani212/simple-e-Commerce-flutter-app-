import 'package:flutter/material.dart';
import 'package:app/preference.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: ListView(
        children: [
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text("Préférences"),
            subtitle: const Text('Aller aux préférences'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PreferencePage()),
            ),
          ),
        ],
      ),
    );
  }
}
