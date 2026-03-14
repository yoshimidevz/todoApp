import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/messages/app_categories.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static const _key = 'custom_categories';

  @override
  Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final custom = prefs.getStringList(_key) ?? [];
    return [...AppCategories.defaults, ...custom];
  }

  @override
  Future<void> addCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final custom = prefs.getStringList(_key) ?? [];
    if (!custom.contains(category)) {
      custom.add(category);
      await prefs.setStringList(_key, custom);
    }
  }
}