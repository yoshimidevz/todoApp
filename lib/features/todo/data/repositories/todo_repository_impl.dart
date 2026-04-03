import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/entities/note_entity.dart';

class TodoRepositoryImpl implements TodoRepository {
  final List<TodoEntity> _todos = [];

  @override
  List<TodoEntity> getTodos() => List.unmodifiable(_todos);

  @override
  void addTodo(TodoEntity todo) => _todos.add(todo);

  @override
  void toggleFavorite(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isFavorite: !_todos[index].isFavorite);
    }
  }

  @override
  void toggleToday(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isToday: !_todos[index].isToday);
    }
  }

  @override
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
  }

  @override
  void setRepeat(String id, RepeatInterval repeat) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(repeat: repeat);
    }
  }

  @override
  void addNote(String todoId, NoteEntity note) {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      final updated = List<NoteEntity>.from(_todos[index].notes)..add(note);
      _todos[index] = _todos[index].copyWith(notes: updated);
    }
  }

  @override
  void updateNote(String todoId, NoteEntity note) {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      final updated = _todos[index].notes
          .map((n) => n.id == note.id ? note : n)
          .toList();
      _todos[index] = _todos[index].copyWith(notes: updated);
    }
  }

  @override
  void deleteNote(String todoId, String noteId) {
    final index = _todos.indexWhere((t) => t.id == todoId);
    if (index != -1) {
      final updated = _todos[index].notes
          .where((n) => n.id != noteId)
          .toList();
      _todos[index] = _todos[index].copyWith(notes: updated);
    }
  }
}