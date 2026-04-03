class NoteEntity {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  NoteEntity copyWith({String? title, String? content}) => NoteEntity(
    id: id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt,
  );
}