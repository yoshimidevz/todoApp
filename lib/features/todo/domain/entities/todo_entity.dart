class TodoEntity {
  final String id;
  final String title;
  final bool isDone;

  const TodoEntity({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  TodoEntity copyWith({bool? isDone}) => TodoEntity(
    id: id,
    title: title,
    isDone: isDone ?? this.isDone,
  );
}