abstract class CategoryRepository {
  Future<List<String>> getCategories();
  Future<void> addCategory(String category);
}