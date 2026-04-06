import 'package:flutter_application_2/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import 'todo_state.dart';
import '../../domain/entities/note_entity.dart';
import '../../../../core/services/notification_service.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;

  TodoCubit(this._repository) : super(const TodoState()) {
    _load();
  }

  void _load() => emit(state.copyWith(todos: _repository.getTodos()));

  void add(String title, String dueDate, String category) {  
    final todo = TodoEntity(
      id: DateTime.now().toString(),
      title: title,
      dueDate: dueDate.isEmpty ? null : dueDate,
      category: category,
    );
    _repository.addTodo(todo);
    _load();
  }
  void toggle(String id) {
    final updated = state.todos.map((t) {
      return t.id == id ? t.copyWith(isDone: !t.isDone) : t;
    }).toList();
    emit(state.copyWith(todos: updated));
  }
  void toggleFavorite(String id) {
    _repository.toggleFavorite(id);
    _load();
  }
  void search(String query) {
    emit(state.copyWith(filter: query));
  }
  void toggleToday(String id) {
    _repository.toggleToday(id);
    _load();
  }
  void delete(String id) {
    _repository.deleteTodo(id);
    _load();
  }
  void setRepeat(String id, RepeatInterval repeat) {
    _repository.setRepeat(id, repeat);
    _load();
  }
  void addNote(String todoId, String title, String content) {
    final note = NoteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    _repository.addNote(todoId, note);
    _load();
  }
  void updateNote(String todoId, NoteEntity note) {
    _repository.updateNote(todoId, note);
    _load();
  }
  void deleteNote(String todoId, String noteId) {
    _repository.deleteNote(todoId, noteId);
    _load();
  }
  void setReminder(String id, DateTime? reminderAt) {
    _repository.setReminder(id, reminderAt);
    if (reminderAt != null) {
      NotificationService.schedule(
        id: id.hashCode,
        title: state.todos.firstWhere((t) => t.id == id).title,
        scheduledAt: reminderAt,
      );
    } else {
      NotificationService.cancel(id.hashCode);
    }
    _load();
  }
}