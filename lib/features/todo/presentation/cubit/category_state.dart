class CategoryState {
  final List<String> categories;
  const CategoryState({this.categories = const []});

  CategoryState copyWith({List<String>? categories}) =>
      CategoryState(categories: categories ?? this.categories);
}