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

  const TodoEntity({
    required this.id,
    required this.title,
    this.isDone = false,
    this.isFavorite = false,
    this.dueDate,
    this.category = 'Pessoal',
    this.isToday = false,
    this.repeat = RepeatInterval.none,
  });

  TodoEntity copyWith({bool? isDone, bool? isFavorite, String? dueDate, String? category, bool? isToday, RepeatInterval? repeat}) => TodoEntity(
    id: id,
    title: title,
    isDone: isDone ?? this.isDone,
    isFavorite: isFavorite ?? this.isFavorite,
    dueDate: dueDate ?? this.dueDate,
    category: category ?? this.category,
    isToday: isToday ?? this.isToday,
    repeat: repeat ?? this.repeat,
  );
}