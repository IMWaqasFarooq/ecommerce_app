import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce_app/features/products/presentation/providers/product_list_notifier.dart';
import 'package:ecommerce_app/features/products/presentation/providers/product_list_state.dart';
import 'package:ecommerce_app/features/products/presentation/providers/product_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class _MockGetProductsByCategoryUseCase extends Mock implements GetProductsByCategoryUseCase {}

Product _product(int id) => Product(
      id: id,
      title: 'Product $id',
      description: 'Description',
      category: 'beauty',
      price: 10,
      discountPercentage: 0,
      rating: 4.5,
      stock: 5,
      brand: 'Brand',
      thumbnail: 'https://example.com/$id.png',
      images: const [],
      availabilityStatus: 'In Stock',
      reviews: const <ProductReview>[],
    );

void main() {
  late _MockGetProductsUseCase getProducts;
  late _MockGetProductsByCategoryUseCase getProductsByCategory;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const GetProductsParams(page: 1, limit: 20));
  });

  setUp(() {
    getProducts = _MockGetProductsUseCase();
    getProductsByCategory = _MockGetProductsByCategoryUseCase();
    container = ProviderContainer(
      overrides: [
        getProductsUseCaseProvider.overrideWithValue(getProducts),
        getProductsByCategoryUseCaseProvider.overrideWithValue(getProductsByCategory),
      ],
    );
    addTearDown(container.dispose);
  });

  test('loads the first page on build', () async {
    when(() => getProducts(any())).thenAnswer(
      (_) async => Right((products: [_product(1), _product(2)], total: 40)),
    );

    container.listen(productListProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    final state = container.read(productListProvider);
    expect(state.status, ProductListStatus.success);
    expect(state.products, hasLength(2));
    expect(state.currentPage, 1);
  });

  test('loadMore appends the next page and advances currentPage', () async {
    when(() => getProducts(const GetProductsParams(page: 1, limit: 20))).thenAnswer(
      (_) async => Right((products: List.generate(20, _product), total: 40)),
    );
    when(() => getProducts(const GetProductsParams(page: 2, limit: 20))).thenAnswer(
      (_) async => Right((products: List.generate(20, (i) => _product(i + 20)), total: 40)),
    );

    container.listen(productListProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    await container.read(productListProvider.notifier).loadMore();

    final state = container.read(productListProvider);
    expect(state.products, hasLength(40));
    expect(state.currentPage, 2);
    expect(state.hasMore, isTrue);
  });

  test('selectCategory switches to the category endpoint and resets pagination', () async {
    when(() => getProducts(any())).thenAnswer((_) async => Right((products: [_product(1)], total: 1)));
    when(() => getProductsByCategory('beauty')).thenAnswer((_) async => Right([_product(9)]));

    container.listen(productListProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    await container.read(productListProvider.notifier).selectCategory('beauty');

    final state = container.read(productListProvider);
    expect(state.selectedCategory, 'beauty');
    expect(state.products, [_product(9)]);
    expect(state.hasMore, isFalse);
  });

  test('surfaces a failure without clearing already-loaded products', () async {
    when(() => getProducts(const GetProductsParams(page: 1, limit: 20)))
        .thenAnswer((_) async => Right((products: List.generate(20, _product), total: 40)));
    when(() => getProducts(const GetProductsParams(page: 2, limit: 20)))
        .thenAnswer((_) async => const Left(Failure.network()));

    container.listen(productListProvider, (previous, next) {});
    await Future<void>.delayed(Duration.zero);

    await container.read(productListProvider.notifier).loadMore();

    final state = container.read(productListProvider);
    expect(state.status, ProductListStatus.failure);
    expect(state.failure, const Failure.network());
    expect(state.products, List.generate(20, _product));
  });
}
