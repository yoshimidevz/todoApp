class TodoEntity {
  final String id;
  final String title;
  final bool isDone;
  final bool isFavorite;
  final String? dueDate;
  final String category;

  const TodoEntity({
    required this.id,
    required this.title,
    this.isDone = false,
    this.isFavorite = false,
    this.dueDate,
    this.category = 'Pessoal',
  });

  TodoEntity copyWith({bool? isDone, bool? isFavorite, String? dueDate, String? category}) => TodoEntity(
    id: id,
    title: title,
    isDone: isDone ?? this.isDone,
    isFavorite: isFavorite ?? this.isFavorite,
    dueDate: dueDate ?? this.dueDate,
    category: category ?? this.category,
  );
}