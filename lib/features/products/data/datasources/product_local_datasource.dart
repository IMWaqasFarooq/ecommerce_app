import 'package:hive/hive.dart';

import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>?> getCachedProducts({required int page, required int limit});
  Future<void> cacheProducts(List<ProductModel> products, {required int page, required int limit});
  Future<ProductModel?> getCachedProductDetail(int id);
  Future<void> cacheProductDetail(ProductModel product);
  Future<List<ProductModel>?> getCachedProductsByCategory(String category);
  Future<void> cacheProductsByCategory(String category, List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  Future<List<ProductModel>?> getCachedProducts({required int page, required int limit}) async {
    final raw = _box.get('products_page_${page}_$limit') as List<dynamic>?;
    if (raw == null) return null;
    return raw
        .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  @override
  Future<void> cacheProducts(
    List<ProductModel> products, {
    required int page,
    required int limit,
  }) {
    return _box.put('products_page_${page}_$limit', products.map((p) => p.toJson()).toList());
  }

  @override
  Future<ProductModel?> getCachedProductDetail(int id) async {
    final raw = _box.get('product_detail_$id');
    if (raw == null) return null;
    return ProductModel.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  @override
  Future<void> cacheProductDetail(ProductModel product) {
    return _box.put('product_detail_${product.id}', product.toJson());
  }

  @override
  Future<List<ProductModel>?> getCachedProductsByCategory(String category) async {
    final raw = _box.get('products_category_$category') as List<dynamic>?;
    if (raw == null) return null;
    return raw
        .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  @override
  Future<void> cacheProductsByCategory(String category, List<ProductModel> products) {
    return _box.put('products_category_$category', products.map((p) => p.toJson()).toList());
  }
}
