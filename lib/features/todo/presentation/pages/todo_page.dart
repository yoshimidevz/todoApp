import 'package:flutter/material.dart';
import '../../../../core/messages/app_messages.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../features/todo/domain/entities/todo_entity.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<TodoEntity> _todos = [];

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _todos.add(TodoEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _controller.text.trim(),
      ));
    });
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
                itemBuilder: (context, i) {
                  final todo = _todos[i];
                  return ListTile(
                    title: Text(todo.title),
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) => setState(() {
                        _todos[i] = todo.copyWith(isDone: !todo.isDone);
                      }),
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