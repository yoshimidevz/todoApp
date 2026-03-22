import '../entities/todo_entity.dart';

abstract class TodoRepository {
  List<TodoEntity> getTodos();
  void addTodo(TodoEntity todo);
  void toggleFavorite(String id);
  void toggleToday(String id);
  void deleteTodo(String id);
  void setRepeat(String id, RepeatInterval repeat);
}