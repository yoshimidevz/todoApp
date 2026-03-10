import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  void add(String title) {
    final todo = TodoEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  void toggle(String id) {
    final updated = state.todos.map((t) {
      return t.id == id ? t.copyWith(isDone: !t.isDone) : t;
    }).toList();
    emit(state.copyWith(todos: updated));
  }
}