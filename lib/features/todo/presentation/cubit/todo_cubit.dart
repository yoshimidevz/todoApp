import 'package:flutter_application_2/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;

  TodoCubit(this._repository) : super(const TodoState()) {
    _load();
  }

  void _load() => emit(state.copyWith(todos: _repository.getTodos()));

  void add(String title, String dueDate) {  
    final todo = TodoEntity(
      id: DateTime.now().toString(),
      title: title,
      dueDate: dueDate.isEmpty ? null : dueDate,
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
}