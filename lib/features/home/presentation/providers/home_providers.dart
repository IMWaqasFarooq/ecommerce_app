import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../categories/presentation/providers/categories_provider.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/usecases/get_products_usecase.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../domain/entities/product_banner.dart';
import '../../domain/services/home_curation.dart';

part 'home_providers.g.dart';

@riverpod
Future<List<Product>> homeProductPool(Ref ref) async {
  final result = await ref.watch(getProductsUseCaseProvider)(
    const GetProductsParams(page: 1, limit: 0),
  );
  return result.fold((failure) => throw failure, (data) => data.products);
}

@riverpod
Future<List<ProductBanner>> discountBanners(Ref ref) async {
  final pool = await ref.watch(homeProductPoolProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  return buildDiscountBanners(pool, categories);
}

@riverpod
Future<List<CategorySpotlight>> categorySpotlights(Ref ref) async {
  final pool = await ref.watch(homeProductPoolProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  return buildCategorySpotlights(pool, categories);
}

@riverpod
Future<List<Product>> trendingProducts(Ref ref) async {
  final pool = await ref.watch(homeProductPoolProvider.future);
  return topRatedProducts(pool);
}

@riverpod
Future<List<Product>> youMayLikeProducts(Ref ref) async {
  final pool = await ref.watch(homeProductPoolProvider.future);
  return randomProductSample(pool);
}
