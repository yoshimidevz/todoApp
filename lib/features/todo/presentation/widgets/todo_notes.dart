import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/note_entity.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

class TodoNotes extends StatefulWidget {
  final String todoId;

  const TodoNotes({super.key, required this.todoId});

  @override
  State<TodoNotes> createState() => _TodoNotesState();
}

class _TodoNotesState extends State<TodoNotes> {
  void _showNoteDialog({NoteEntity? existing}) {
    final titleController   = TextEditingController(text: existing?.title);
    final contentController = TextEditingController(text: existing?.content);
    final cubit = context.read<TodoCubit>();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existing == null ? 'Nova anotação' : 'Editar anotação',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Anotação'),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (existing != null)
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      label: Text(
                        'Excluir',
                        style: AppTextStyles.body.copyWith(color: AppColors.error),
                      ),
                      onPressed: () {
                        cubit.deleteNote(widget.todoId, existing.id);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Cancelar',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                    final title   = titleController.text.trim();
                    final content = contentController.text.trim();
                    if (title.isEmpty && content.isEmpty) return;
                      if (existing == null) {
                        cubit.addNote(widget.todoId, title, content); 
                      } else {
                        cubit.updateNote(
                          widget.todoId,
                          existing.copyWith(title: title, content: content),
                        );
                      }
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final todo = state.todos.firstWhere(
          (t) => t.id == widget.todoId,
          orElse: () => state.todos.first,
        );
        final notes = todo.notes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Anotações',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  onPressed: () => _showNoteDialog(),
                ),
              ],
            ),
            if (notes.isEmpty)
              Text('Nenhuma anotação ainda.', style: AppTextStyles.caption),
            if (notes.isNotEmpty)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
                children: notes.map((note) => GestureDetector(
                  onTap: () => _showNoteDialog(existing: note),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            note.content,
                            style: AppTextStyles.caption,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${note.createdAt.day}/${note.createdAt.month}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
          ],
        );
      },
    );
  }
}