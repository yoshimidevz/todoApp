import 'package:flutter/material.dart';
import '../../../../core/messages/app_messages.dart';
import '../../../../core/validators/app_validators.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _todos = ['testar aplicação', 'jogar valorant'];
  
  void _add() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _todos.add(_controller.text.trim()));
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
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      validator: AppValidators.todoTitle,
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