import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/masks/app_masks.dart';
import '../../../../../core/messages/app_messages.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../../../core/patterns/buttons/app_button.dart';
import '../../../../../core/patterns/inputs/app_text_field.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../cubit/todo_cubit.dart';

class TodoForm extends StatelessWidget {
  const TodoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryCubit>(),
      child: const _TodoFormView(),
    );
  }
}

class _TodoFormView extends StatefulWidget {
  const _TodoFormView();

  @override
  State<_TodoFormView> createState() => _TodoFormViewState();
}
class _TodoFormViewState extends State<_TodoFormView> {
  final _controller     = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey        = GlobalKey<FormState>();
  String? _selectedCategory;

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TodoCubit>().add(
      _controller.text.trim(),
      _dateController.text.trim(),
      _selectedCategory!,
    );
    _controller.clear();
    _dateController.clear();
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova categoria'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome da categoria'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<CategoryCubit>().addCategory(name);
                setState(() => _selectedCategory = name);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        if (_selectedCategory == null && categoryState.categories.isNotEmpty) {
          _selectedCategory = categoryState.categories.first;
        }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _controller,
                        hintText: AppMessages.todoHint,
                        validator: (value) {
                          final todoState = context.read<TodoCubit>().state;
                          return AppValidators.todoTitle(value) ??
                              AppValidators.existingTodo(
                                value,
                                _selectedCategory ?? '',
                                todoState.todos
                                    .map((t) => {'title': t.title, 'category': t.category})
                                    .toList(),
                              );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: AppMessages.addButton,
                      onPressed: _add,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _dateController,
                  hintText: 'Vencimento: DD/MM/AAAA',
                  inputFormatters: [AppMasks.date],
                  validator: AppValidators.dueDate,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(labelText: 'Categoria'),
                        items: categoryState.categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Nova categoria',
                      onPressed: _showAddCategoryDialog,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}