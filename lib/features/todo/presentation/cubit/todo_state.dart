import '../../domain/entities/todo_entity.dart';

class TodoState {
  final List<TodoEntity> todos;
  const TodoState({this.todos = const []});

  TodoState copyWith({List<TodoEntity>? todos}) => 
    TodoState(todos: todos ?? this.todos);

}