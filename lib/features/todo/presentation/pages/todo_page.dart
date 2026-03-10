import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/di/injection.dart';
import 'package:flutter_application_2/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../../../core/messages/app_messages.dart';
import '../../../../core/validators/app_validators.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../../../../core/masks/app_masks.dart';
import '../../../../core/messages/app_categories.dart';
import '../../../../core/routes/app_routes.dart';

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
  final _dateController = TextEditingController();
  String _selectedCategory = AppCategories.personal;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TodoCubit>().add( 
      _controller.text.trim(),
      _dateController.text.trim(),
      _selectedCategory,
    );
    _controller.clear();
    _dateController.clear();
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
              child: Column(
                children: [
                  Row(
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
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dateController,
                    inputFormatters: [AppMasks.date],
                    decoration: const InputDecoration(
                      hintText: 'Vencimento: DD/MM/AAAA',
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: AppCategories.all
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedCategory = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar tarefas...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => context.read<TodoCubit>().search(value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) {
                  if (state.filteredTodos.isEmpty) {
                    return const Center(child: Text(AppMessages.emptyList));
                  }
                  return ListView.builder(
                    itemCount: state.filteredTodos.length,
                    itemBuilder: (context, i) {
                      final todo = state.filteredTodos[i];
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todo.category),
                            if (todo.dueDate != null && todo.dueDate!.isNotEmpty)
                              Text('Vence em ${todo.dueDate}'),
                          ],
                        ),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) => context.read<TodoCubit>().toggle(todo.id),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                todo.isFavorite ? Icons.star : Icons.star_border,
                                color: todo.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () => context.read<TodoCubit>().toggleFavorite(todo.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, size: 16),
                              onPressed: () => context.go(
                                AppRoutes.todoDetail,
                                extra: todo,                        
                              ),
                            ),
                          ],
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