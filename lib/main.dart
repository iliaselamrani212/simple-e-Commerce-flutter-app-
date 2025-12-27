import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/MainScreen.dart';
import 'package:app/etat.dart';
import 'package:app/preference.dart';
import 'package:app/history_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Panier_etat()),
        ChangeNotifierProvider(create: (_) => Preference()),
        ChangeNotifierProvider(create: (_) => HistoryState()),
      ],
      child: const SmartShopApp(),
    ),
  );
}

class SmartShopApp extends StatefulWidget {
  const SmartShopApp({super.key});

  @override
  State<SmartShopApp> createState() => _SmartShopAppState();
}

class _SmartShopAppState extends State<SmartShopApp> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<Preference>().loadTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<Preference>().isDarkMode;

    return MaterialApp(
      title: 'SmartShop ENIAD',
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainScreen(),
    );
  }
}
