import 'note_entity.dart';
import 'attachment_entity.dart';

enum RepeatInterval { none, daily, weekly, monthly }

class TodoEntity {
  final String id;
  final String title;
  final bool isDone;
  final bool isFavorite;
  final String? dueDate;
  final String category;
  final bool isToday;
  final RepeatInterval repeat;
  final List<NoteEntity> notes;
  final DateTime? reminderAt;
  final List<AttachmentEntity> attachments;

  const TodoEntity({
    required this.id,
    required this.title,
    this.isDone = false,
    this.isFavorite = false,
    this.dueDate,
    this.category = 'Pessoal',
    this.isToday = false,
    this.repeat = RepeatInterval.none,
    this.notes = const [],
    this.reminderAt,
    this.attachments = const [],
  });

  TodoEntity copyWith({bool? isDone, bool? isFavorite, String? dueDate, String? category, bool? isToday, RepeatInterval? repeat, List<NoteEntity>? notes, DateTime? reminderAt, List<AttachmentEntity>? attachments}) => TodoEntity(
    id: id,
    title: title,
    isDone: isDone ?? this.isDone,
    isFavorite: isFavorite ?? this.isFavorite,
    dueDate: dueDate ?? this.dueDate,
    category: category ?? this.category,
    isToday: isToday ?? this.isToday,
    repeat: repeat ?? this.repeat,
    notes: notes ?? this.notes,
    reminderAt: reminderAt ?? this.reminderAt,
    attachments: attachments ?? this.attachments,
  );
}