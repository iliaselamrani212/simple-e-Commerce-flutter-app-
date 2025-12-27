import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryState extends ChangeNotifier {
  final List<String> _actions = [];

  List<String> get actions => List.unmodifiable(_actions);

  void addAction(String action) {
    _actions.insert(0, "${DateTime.now().toString().substring(0, 16)} - $action");
    notifyListeners();
  }

  void removeAction(int index) {
    if (index >= 0 && index < _actions.length) {
      _actions.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _actions.clear();
    notifyListeners();
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryState>();
    final actions = history.actions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des actions"),
      ),
      floatingActionButton: actions.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                 context.read<HistoryState>().clear();
              },
              child: const Icon(Icons.delete),
            )
          : null,
      body: actions.isEmpty
          ? const Center(child: Text("Aucune action pour le moment"))
          : ListView.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(actions[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<HistoryState>().removeAction(index);
                    },
                  ),
                );
              },
            ),
    );
  }
}
