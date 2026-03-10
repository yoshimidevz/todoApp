import 'package:flutter/material.dart';
import '../../domain/entities/todo_entity.dart';


class TodoDetailPage extends StatelessWidget {
  final TodoEntity todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailItem(label: 'Título', value: todo.title),
            _DetailItem(label: 'Categoria', value: todo.category),
            _DetailItem(
              label: 'Vencimento',
              value: todo.dueDate ?? 'Sem data',
            ),
            _DetailItem(
              label: 'Status',
              value: todo.isDone ? 'Concluída' : 'Pendente',
            ),
            _DetailItem(
              label: 'Favorita',
              value: todo.isFavorite ? 'Sim' : 'Não',
            ),
            const Divider(height: 32),
            // reservado pra "Para fazer hoje"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Para fazer hoje',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: false, // fixo por enquanto, implementar depois
                  onChanged: null, // desabilitado por enquanto
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// widget auxiliar pra cada linha de detalhe
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