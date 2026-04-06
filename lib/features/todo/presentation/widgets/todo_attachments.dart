import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/attachment_entity.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

class TodoAttachments extends StatelessWidget {
  final String todoId;

  const TodoAttachments({super.key, required this.todoId});

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.name.isEmpty) return;

    final attachment = AttachmentEntity(
      name: file.name,
      path: file.name,
      sizeInBytes: file.size,
    );

    if (!context.mounted) return;
    context.read<TodoCubit>().addAttachment(todoId, attachment);
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final todo = state.todos.firstWhere(
          (t) => t.id == todoId,
          orElse: () => state.todos.first,
        );
        final attachments = todo.attachments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Anexos',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: AppColors.primary),
                  onPressed: () => _pickFile(context),
                ),
              ],
            ),
            if (attachments.isEmpty)
              Text('Nenhum anexo ainda.', style: AppTextStyles.caption),
            if (attachments.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insert_drive_file_outlined,
                        color: AppColors.primary),
                    title: Text(attachment.name, style: AppTextStyles.body),
                    subtitle: Text(_formatSize(attachment.sizeInBytes),
                        style: AppTextStyles.caption),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => context
                          .read<TodoCubit>()
                          .deleteAttachment(todoId, attachment.path),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}