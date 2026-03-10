import '../../domain/entities/todo_entity.dart';

class TodoState {
  final List<TodoEntity> todos;
  final String filter;  // ← novo

  const TodoState({
    this.todos = const [],
    this.filter = '',   // ← padrão vazio
  });

  TodoState copyWith({List<TodoEntity>? todos, String? filter}) => TodoState(
    todos: todos ?? this.todos,
    filter: filter ?? this.filter,
  );

  // lista filtrada — calculada na hora
  List<TodoEntity> get filteredTodos {
    if (filter.isEmpty) return todos;
    return todos.where((t) =>
      t.title.toLowerCase().contains(filter.toLowerCase())
    ).toList();
  }
}