import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/di/injection.dart';
import 'package:flutter_application_2/features/todo/domain/repositories/todo_repository.dart';
import '../../../../features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/messages/app_messages.dart';
import '../../../../core/validators/app_validators.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TodoCubit>(),
      child: const _TodoView(),
    );
  }
}

class _TodoView extends StatefulWidget {
  const _TodoView();

  @override
  State<_TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<_TodoView> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TodoCubit>().add(_controller.text.trim());
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
              child: BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) {
                  if (state.todos.isEmpty) {
                    return const Center(child: Text(AppMessages.emptyList));
                  }
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, i) {
                      final todo = state.todos[i];
                      return ListTile(
                        title: Text(todo.title),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) =>
                              context.read<TodoCubit>().toggle(todo.id),
                        ),
                      );
                    },
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