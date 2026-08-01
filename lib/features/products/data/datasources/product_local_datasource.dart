import 'package:hive/hive.dart';

import '../../domain/entities/product_sort.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>?> getCachedProducts({
    required int page,
    required int limit,
    ProductSort sort = ProductSort.featured,
  });
  Future<void> cacheProducts(
    List<ProductModel> products, {
    required int page,
    required int limit,
    ProductSort sort = ProductSort.featured,
  });
  Future<ProductModel?> getCachedProductDetail(int id);
  Future<void> cacheProductDetail(ProductModel product);
  Future<List<ProductModel>?> getCachedProductsByCategory(
    String category, {
    ProductSort sort = ProductSort.featured,
  });
  Future<void> cacheProductsByCategory(
    String category,
    List<ProductModel> products, {
    ProductSort sort = ProductSort.featured,
  });
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  Future<List<ProductModel>?> getCachedProducts({
    required int page,
    required int limit,
    ProductSort sort = ProductSort.featured,
  }) async {
    final raw = _box.get('products_page_${page}_${limit}_${sort.name}') as List<dynamic>?;
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
    ProductSort sort = ProductSort.featured,
  }) {
    return _box.put(
      'products_page_${page}_${limit}_${sort.name}',
      products.map((p) => p.toJson()).toList(),
    );
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
  Future<List<ProductModel>?> getCachedProductsByCategory(
    String category, {
    ProductSort sort = ProductSort.featured,
  }) async {
    final raw = _box.get('products_category_${category}_${sort.name}') as List<dynamic>?;
    if (raw == null) return null;
    return raw
        .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  @override
  Future<void> cacheProductsByCategory(
    String category,
    List<ProductModel> products, {
    ProductSort sort = ProductSort.featured,
  }) {
    return _box.put(
      'products_category_${category}_${sort.name}',
      products.map((p) => p.toJson()).toList(),
    );
  }
}
