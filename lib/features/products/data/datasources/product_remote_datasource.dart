import 'package:dio/dio.dart';

import '../models/product_list_response_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductListResponseModel> getProducts({required int page, required int limit});
  Future<ProductModel> getProductDetail(int id);
  Future<ProductListResponseModel> getProductsByCategory(String category);
  Future<ProductListResponseModel> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<ProductListResponseModel> getProducts({required int page, required int limit}) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {'limit': limit, 'skip': (page - 1) * limit},
      options: Options(extra: {'requiresAuth': false}),
    );
    return ProductListResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    final response = await _dio.get('/products/$id', options: Options(extra: {'requiresAuth': false}));
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProductListResponseModel> getProductsByCategory(String category) async {
    final response = await _dio.get(
      '/products/category/$category',
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
}
