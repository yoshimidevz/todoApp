import 'package:get_it/get_it.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/presentation/cubit/todo_cubit.dart';
import '../../features/todo/data/repositories/category_repository_impl.dart';
import '../../features/todo/domain/repositories/category_repository.dart';
import '../../features/todo/presentation/cubit/category_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl());
  getIt.registerFactory(() => TodoCubit(getIt<TodoRepository>()));
  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());
  getIt.registerFactory(() => CategoryCubit(getIt()));
}