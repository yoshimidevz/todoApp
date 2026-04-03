import '../../domain/entities/todo_entity.dart';

class TodoState {
  final List<TodoEntity> todos;
  final String filter; 

  const TodoState({
    this.todos = const [],
    this.filter = '',  
  });

  TodoState copyWith({List<TodoEntity>? todos, String? filter}) => TodoState(
    todos: todos ?? this.todos,
    filter: filter ?? this.filter,
  );

  List<TodoEntity> get filteredTodos {
    if (filter.isEmpty) return todos;
    return todos.where((t) =>
      t.title.toLowerCase().contains(filter.toLowerCase())
    ).toList();
  }
}