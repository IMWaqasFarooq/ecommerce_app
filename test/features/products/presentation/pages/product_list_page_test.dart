import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/preferences/locale_notifier.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/categories/domain/entities/category.dart';
import 'package:ecommerce_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app/features/categories/presentation/providers/category_providers.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_sort.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce_app/features/products/presentation/pages/product_list_page.dart';
import 'package:ecommerce_app/features/products/presentation/providers/product_list_notifier.dart';
import 'package:ecommerce_app/features/products/presentation/providers/product_providers.dart';
import 'package:ecommerce_app/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:ecommerce_app/features/wishlist/domain/usecases/toggle_wishlist_usecase.dart';
import 'package:ecommerce_app/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:ecommerce_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class _MockGetProductsByCategoryUseCase extends Mock implements GetProductsByCategoryUseCase {}

class _MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class _MockGetWishlistUseCase extends Mock implements GetWishlistUseCase {}

class _MockToggleWishlistUseCase extends Mock implements ToggleWishlistUseCase {}

class _TestLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('en');
}

Product _product(int id, {String category = 'beauty'}) => Product(
  id: id,
  title: 'Product $id',
  description: 'Description',
  category: category,
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
  late _MockGetCategoriesUseCase getCategories;
  late _MockGetWishlistUseCase getWishlist;
  late _MockToggleWishlistUseCase toggleWishlist;

  setUpAll(() {
    registerFallbackValue(const GetProductsParams(page: 1, limit: 20));
    registerFallbackValue(const GetProductsByCategoryParams(category: ''));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getProducts = _MockGetProductsUseCase();
    getProductsByCategory = _MockGetProductsByCategoryUseCase();
    getCategories = _MockGetCategoriesUseCase();
    getWishlist = _MockGetWishlistUseCase();
    toggleWishlist = _MockToggleWishlistUseCase();

    when(() => getProducts(any())).thenAnswer((_) async => Right((products: [_product(1)], total: 1)));
    when(
      () => getProductsByCategory(any()),
    ).thenAnswer((_) async => Right([_product(2, category: 'furniture')]));
    when(
      () => getCategories(any()),
    ).thenAnswer((_) async => const Right([Category(slug: 'furniture', name: 'Furniture')]));
    when(() => getWishlist(any())).thenAnswer((_) async => const Right([]));
  });

  overrides() => [
    getProductsUseCaseProvider.overrideWithValue(getProducts),
    getProductsByCategoryUseCaseProvider.overrideWithValue(getProductsByCategory),
    getCategoriesUseCaseProvider.overrideWithValue(getCategories),
    getWishlistUseCaseProvider.overrideWithValue(getWishlist),
    toggleWishlistUseCaseProvider.overrideWithValue(toggleWishlist),
    localeProvider.overrideWith(_TestLocaleNotifier.new),
  ];

  Widget wrap(Widget child) => ProviderScope(
    overrides: overrides(),
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );

  testWidgets('with no initial params, loads the default unfiltered page', (tester) async {
    await tester.pumpWidget(wrap(const ProductListPage()));
    await tester.pumpAndSettle();

    verify(() => getProducts(const GetProductsParams(page: 1, limit: 20))).called(1);
    verifyNever(() => getProductsByCategory(any()));
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Shop')),
      findsOneWidget,
    );
  });

  testWidgets('applies initialCategory on entry and shows the category name as the title', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const ProductListPage(initialCategory: 'furniture')));
    await tester.pumpAndSettle();

    verify(() => getProductsByCategory(const GetProductsByCategoryParams(category: 'furniture')))
        .called(1);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Furniture')),
      findsOneWidget,
    );
  });

  testWidgets('applies initialSort on entry', (tester) async {
    when(
      () => getProducts(const GetProductsParams(page: 1, limit: 20, sort: ProductSort.ratingHighToLow)),
    ).thenAnswer((_) async => Right((products: [_product(3)], total: 1)));

    final container = ProviderContainer(overrides: overrides());
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProductListPage(initialSort: ProductSort.ratingHighToLow),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(container.read(productListProvider).sort, ProductSort.ratingHighToLow);
  });
}
