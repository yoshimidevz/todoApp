import 'package:get_it/get_it.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/presentation/cubit/todo_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl());
  getIt.registerFactory(() => TodoCubit(getIt<TodoRepository>()));
}