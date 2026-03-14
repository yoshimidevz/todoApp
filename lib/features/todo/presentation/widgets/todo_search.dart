import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/todo_cubit.dart';

class TodoSearch extends StatelessWidget {
  const TodoSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Buscar tarefas...',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) => context.read<TodoCubit>().search(value),
    );
  }
}