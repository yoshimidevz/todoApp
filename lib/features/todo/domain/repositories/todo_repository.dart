import '../entities/todo_entity.dart';

abstract class TodoRepository {
  List<TodoEntity> getTodos();
  void addTodo(TodoEntity todo);
  void toggleFavorite(String id);
}