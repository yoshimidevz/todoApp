import '../entities/todo_entity.dart';
import '../entities/note_entity.dart';

abstract class TodoRepository {
  List<TodoEntity> getTodos();
  void addTodo(TodoEntity todo);
  void toggleFavorite(String id);
  void toggleToday(String id);
  void deleteTodo(String id);
  void setRepeat(String id, RepeatInterval repeat);
  void addNote(String todoId, NoteEntity note);
  void updateNote(String todoId, NoteEntity note);
  void deleteNote(String todoId, String noteId);
  void setReminder(String id, DateTime? reminderAt);
}