import 'package:hive/hive.dart';

import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>?> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  static const _key = 'categories';

  @override
  Future<List<CategoryModel>?> getCachedCategories() async {
    final raw = _box.get(_key) as List<dynamic>?;
    if (raw == null) return null;
    return raw
        .map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) {
    return _box.put(_key, categories.map((c) => c.toJson()).toList());
  }
}
