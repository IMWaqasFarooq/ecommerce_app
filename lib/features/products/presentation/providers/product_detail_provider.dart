import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';
import 'product_providers.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<Product> productDetail(Ref ref, int productId) async {
  final result = await ref.watch(getProductDetailUseCaseProvider)(productId);
  return result.fold((failure) => throw failure, (product) => product);
}

@riverpod
Future<List<Product>> relatedProducts(Ref ref, String category, int excludeId) async {
  final result = await ref.watch(getProductsByCategoryUseCaseProvider)(category);
  return result.fold(
    (failure) => throw failure,
    (products) => products.where((p) => p.id != excludeId).take(10).toList(),
  );
}
