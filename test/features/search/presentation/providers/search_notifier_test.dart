import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/providers/core_providers.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:ecommerce_app/features/products/domain/usecases/search_products_usecase.dart';
import 'package:ecommerce_app/features/products/presentation/providers/product_providers.dart';
import 'package:ecommerce_app/features/search/domain/repositories/search_history_repository.dart';
import 'package:ecommerce_app/features/search/presentation/providers/search_notifier.dart';
import 'package:ecommerce_app/features/search/presentation/providers/search_providers.dart';
import 'package:ecommerce_app/features/search/presentation/providers/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_analytics_service.dart';

class _MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

class _MockSearchHistoryRepository extends Mock implements SearchHistoryRepository {}

Product _product(int id, String title) => Product(
  id: id,
  title: title,
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
  late _MockSearchProductsUseCase searchProducts;
  late _MockSearchHistoryRepository searchHistoryRepository;
  late ProviderContainer container;

  setUp(() {
    searchProducts = _MockSearchProductsUseCase();
    searchHistoryRepository = _MockSearchHistoryRepository();
    when(() => searchHistoryRepository.getHistory()).thenReturn(const []);
    when(() => searchHistoryRepository.addQuery(any())).thenAnswer((_) async {});
    when(() => searchHistoryRepository.removeQuery(any())).thenAnswer((_) async {});
    when(() => searchHistoryRepository.clearHistory()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        searchProductsUseCaseProvider.overrideWithValue(searchProducts),
        searchHistoryRepositoryProvider.overrideWithValue(searchHistoryRepository),
        analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(searchProvider, (previous, next) {});
  });

  test('debounces onQueryChanged before calling the search use case', () async {
    when(() => searchProducts('mascara')).thenAnswer((_) async => Right([_product(1, 'Mascara')]));

    final notifier = container.read(searchProvider.notifier);
    notifier.onQueryChanged('m');
    notifier.onQueryChanged('ma');
    notifier.onQueryChanged('mascara');

    verifyNever(() => searchProducts(any()));

    await Future<void>.delayed(const Duration(milliseconds: 600));

    verify(() => searchProducts('mascara')).called(1);
    final state = container.read(searchProvider);
    expect(state.status, SearchStatus.success);
    expect(state.results, [_product(1, 'Mascara')]);
  });

  test('records the query in history after a successful search', () async {
    when(() => searchProducts('phone')).thenAnswer((_) async => Right([_product(2, 'Phone')]));

    await container.read(searchProvider.notifier).submit('phone');

    verify(() => searchHistoryRepository.addQuery('phone')).called(1);
  });

  test('clearing the query resets to idle without searching', () async {
    final notifier = container.read(searchProvider.notifier);
    notifier.onQueryChanged('phone');
    notifier.onQueryChanged('');

    await Future<void>.delayed(const Duration(milliseconds: 600));

    verifyNever(() => searchProducts(any()));
    final state = container.read(searchProvider);
    expect(state.status, SearchStatus.idle);
    expect(state.results, isEmpty);
  });

  test('removeHistoryEntry delegates to the repository and refreshes history', () async {
    when(() => searchHistoryRepository.getHistory()).thenReturn(['phone']);
    container.read(searchProvider.notifier).removeHistoryEntry('phone');

    verify(() => searchHistoryRepository.removeQuery('phone')).called(1);
  });
}
