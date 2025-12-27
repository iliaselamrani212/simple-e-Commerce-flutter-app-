import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mohamed Boudchiche',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Maître de Conférences – ENIAD',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text('Ilias el amrani'),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.teal),
              title: Text('+212 6 75 36 16 50'),
            ),
            const ListTile(
              leading: Icon(Icons.location_on, color: Colors.teal),
              title: Text('meknes, Maroc'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Modifier mes informations'),
            )

            ,
          ],
        ),
      ),
    );
  }
}
