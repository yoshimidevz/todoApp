import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(const CategoryState()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    final categories = await _repository.getCategories();
    emit(state.copyWith(categories: categories));
  }

  Future<void> addCategory(String category) async {
    await _repository.addCategory(category);
    await loadCategories();
  }
}