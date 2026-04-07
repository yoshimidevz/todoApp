import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web/web.dart' as web;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/attachment_entity.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

class TodoAttachments extends StatefulWidget {
  final String todoId;

  const TodoAttachments({super.key, required this.todoId});

  @override
  State<TodoAttachments> createState() => _TodoAttachmentsState();
}

class _TodoAttachmentsState extends State<TodoAttachments> {
  final _registeredViews = <String>{}; // ✅ controla o que já foi registrado

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.name.isEmpty || file.bytes == null) return;

    final attachment = AttachmentEntity(
      name: file.name,
      path: file.name,
      sizeInBytes: file.size,
      bytes: file.bytes,
    );

    if (!context.mounted) return;
    context.read<TodoCubit>().addAttachment(widget.todoId, attachment);
  }

  void _downloadFile(AttachmentEntity attachment) {
    if (attachment.bytes == null) return;

    final blob = web.Blob([attachment.bytes!.buffer.toJS].toJS);
    final url  = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..setAttribute('download', attachment.name)
      ..click();
    web.URL.revokeObjectURL(url);
  }

  void _previewFile(BuildContext context, AttachmentEntity attachment) {
    if (attachment.bytes == null) return;

    final jsArray = attachment.bytes!.buffer.toJS;
    final blob = web.Blob(
      [jsArray].toJS,
      web.BlobPropertyBag(type: _mimeType(attachment.name)),
    );
    final url = web.URL.createObjectURL(blob);
    // ✅ só registra se ainda não foi registrado
    if (!_registeredViews.contains(url)) {
      _registeredViews.add(url);
      ui_web.platformViewRegistry.registerViewFactory(
        url,
        (int viewId) {
          return web.document.createElement('iframe') as web.HTMLIFrameElement
            ..src = url
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';
        },
      );
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(ctx).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        attachment.name,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        web.URL.revokeObjectURL(url);
                        _registeredViews.remove(url);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: HtmlElementView(viewType: url),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':  return 'application/pdf';
      case 'png':  return 'image/png';
      case 'jpg':
      case 'jpeg': return 'image/jpeg';
      case 'gif':  return 'image/gif';
      case 'txt':  return 'text/plain';
      case 'mp4':  return 'video/mp4';
      default:     return 'application/octet-stream';
    }
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
          (t) => t.id == widget.todoId,
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
                    leading: const Icon(
                      Icons.insert_drive_file_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(attachment.name, style: AppTextStyles.body),
                    subtitle: Text(
                      _formatSize(attachment.sizeInBytes),
                      style: AppTextStyles.caption,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined,
                              color: AppColors.primary),
                          tooltip: 'Visualizar',
                          onPressed: () => _previewFile(context, attachment),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_outlined,
                              color: AppColors.primary),
                          tooltip: 'Baixar',
                          onPressed: () => _downloadFile(attachment),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                          tooltip: 'Excluir',
                          onPressed: () => context
                              .read<TodoCubit>()
                              .deleteAttachment(widget.todoId, attachment.path),
                        ),
                      ],
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