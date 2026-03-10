import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/todo_entity.dart';
import '../cubit/todo_cubit.dart';

class TodoDetailPage extends StatefulWidget {
  final TodoEntity todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late bool _isToday;

  @override
  void initState() {
    super.initState();
    _isToday = widget.todo.isToday;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TodoCubit>(),
      child: Scaffold(
      appBar: AppBar(title: const Text('Detalhes da tarefa')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailItem(label: 'Título', value: widget.todo.title),
              _DetailItem(label: 'Categoria', value: widget.todo.category),
              _DetailItem(
                label: 'Vencimento',
                value: widget.todo.dueDate ?? 'Sem data',
              ),
              _DetailItem(
                label: 'Status',
                value: widget.todo.isDone ? 'Concluída' : 'Pendente',
              ),
              _DetailItem(
                label: 'Favorita',
                value: widget.todo.isFavorite ? 'Sim' : 'Não',
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Para fazer hoje',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _isToday,
                    onChanged: (value) {
                      setState(() => _isToday = value);
                      context.read<TodoCubit>().toggleToday(widget.todo.id); 
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}