import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/product.dart';
import 'product_providers.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<Product> productDetail(Ref ref, int productId) async {
  final result = await ref.watch(getProductDetailUseCaseProvider)(productId);
  final product = result.fold((failure) => throw failure, (product) => product);

  await ref.read(analyticsServiceProvider).logViewProduct(
        productId: product.id,
        name: product.title,
        price: product.price,
      );

  return product;
}

@riverpod
Future<List<Product>> relatedProducts(Ref ref, String category, int excludeId) async {
  final result = await ref.watch(getProductsByCategoryUseCaseProvider)(category);
  return result.fold(
    (failure) => throw failure,
    (products) => products.where((p) => p.id != excludeId).take(10).toList(),
  );
}
