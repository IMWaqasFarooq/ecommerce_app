import 'package:dio/dio.dart';

import '../../domain/entities/product_sort.dart';
import '../models/product_list_response_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductListResponseModel> getProducts({
    required int page,
    required int limit,
    ProductSort sort = ProductSort.featured,
  });
  Future<ProductModel> getProductDetail(int id);
  Future<ProductListResponseModel> getProductsByCategory(
    String category, {
    ProductSort sort = ProductSort.featured,
  });
  Future<ProductListResponseModel> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<ProductListResponseModel> getProducts({
    required int page,
    required int limit,
    ProductSort sort = ProductSort.featured,
  }) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {
        'limit': limit,
        'skip': (page - 1) * limit,
        ..._sortParams(sort),
      },
      options: Options(extra: {'requiresAuth': false}),
    );
    return ProductListResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    final response = await _dio.get(
      '/products/$id',
      options: Options(extra: {'requiresAuth': false}),
    );
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProductListResponseModel> getProductsByCategory(
    String category, {
    ProductSort sort = ProductSort.featured,
  }) async {
    final response = await _dio.get(
      '/products/category/$category',
      queryParameters: _sortParams(sort),
      options: Options(extra: {'requiresAuth': false}),
    );
    return ProductListResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProductListResponseModel> searchProducts(String query) async {
    final response = await _dio.get(
      '/products/search',
      queryParameters: {'q': query},
      options: Options(extra: {'requiresAuth': false}),
    );
    return ProductListResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Map<String, dynamic> _sortParams(ProductSort sort) {
    final sortBy = sort.sortByParam;
    final order = sort.orderParam;
    if (sortBy == null || order == null) return const {};
    return {'sortBy': sortBy, 'order': order};
  }
}
