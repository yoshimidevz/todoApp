class TodoEntity {
  final String id;
  final String title;
  final bool isDone;
  final bool isFavorite;
  final String? dueDate;

  const TodoEntity({
    required this.id,
    required this.title,
    this.isDone = false,
    this.isFavorite = false,
    this.dueDate,
  });

  TodoEntity copyWith({bool? isDone, bool? isFavorite, String? dueDate}) => TodoEntity(
    id: id,
    title: title,
    isDone: isDone ?? this.isDone,
    isFavorite: isFavorite ?? this.isFavorite,
    dueDate: dueDate ?? this.dueDate,
  );
}