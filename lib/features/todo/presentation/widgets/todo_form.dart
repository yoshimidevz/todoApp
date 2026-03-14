import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/masks/app_masks.dart';
import '../../../../../core/messages/app_categories.dart';
import '../../../../../core/messages/app_messages.dart';
import '../../../../../core/validators/app_validators.dart';
import '../cubit/todo_cubit.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({super.key});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _controller     = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey        = GlobalKey<FormState>();
  String _selectedCategory = AppCategories.personal;

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
      _selectedCategory,
    );
    _controller.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  validator: AppValidators.todoTitle,
                  decoration: const InputDecoration(hintText: AppMessages.todoHint),
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
            decoration: const InputDecoration(hintText: 'Vencimento: DD/MM/AAAA'),
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
    );
  }
}