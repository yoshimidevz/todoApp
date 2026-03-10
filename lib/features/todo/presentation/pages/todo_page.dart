import 'package:flutter/material.dart';
import '../../../../core/messages/app_messages.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  final List<String> _todos = ['testar aplicação', 'jogar valorant'];

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _todos.add(text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppMessages.pageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: AppMessages.todoHint,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _add,
                  child: const Text(AppMessages.addButton),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, i) => ListTile(title: Text(_todos[i])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}