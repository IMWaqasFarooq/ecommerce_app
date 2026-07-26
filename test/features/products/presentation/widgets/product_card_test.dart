import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:ecommerce_app/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:ecommerce_app/features/wishlist/domain/usecases/toggle_wishlist_usecase.dart';
import 'package:ecommerce_app/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockToggleWishlistUseCase extends Mock implements ToggleWishlistUseCase {}

class _MockGetWishlistUseCase extends Mock implements GetWishlistUseCase {}

void main() {
  late _MockToggleWishlistUseCase toggleWishlist;
  late _MockGetWishlistUseCase getWishlist;

  const product = Product(
    id: 1,
    title: 'Essence Mascara',
    description: 'A mascara',
    category: 'beauty',
    price: 10,
    discountPercentage: 20,
    rating: 4.5,
    stock: 5,
    brand: 'Essence',
    thumbnail: 'https://example.com/thumb.png',
    images: [],
    availabilityStatus: 'In Stock',
    reviews: <ProductReview>[],
  );

  setUpAll(() {
    registerFallbackValue(
      const ToggleWishlistParams(productId: 0, title: '', thumbnail: '', price: 0),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    toggleWishlist = _MockToggleWishlistUseCase();
    getWishlist = _MockGetWishlistUseCase();
  });

  Widget wrap({List<WishlistItem> wishlist = const [], VoidCallback? onTap}) {
    when(() => getWishlist(any())).thenAnswer((_) async => Right(wishlist));
    return ProviderScope(
      overrides: [
        getWishlistUseCaseProvider.overrideWithValue(getWishlist),
        toggleWishlistUseCaseProvider.overrideWithValue(toggleWishlist),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 300,
            child: ProductCard(product: product, onTap: onTap ?? () {}),
          ),
        ),
      ),
    );
  }

  testWidgets('renders the title, discounted price, and strike-through price', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.text('Essence Mascara'), findsOneWidget);
    expect(find.text('\$8.00'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);
  });

  testWidgets('tapping the card invokes onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(onTap: () => tapped = true));
    await tester.pump();

    await tester.tap(find.text('Essence Mascara'));

    expect(tapped, isTrue);
  });

  testWidgets('shows a filled heart when the product is already wishlisted', (tester) async {
    await tester.pumpWidget(
      wrap(
        wishlist: const [
          WishlistItem(productId: 1, title: 'Essence Mascara', thumbnail: 't', price: 10),
        ],
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });

  testWidgets('tapping the heart toggles the wishlist for this product', (tester) async {
    when(() => toggleWishlist(any())).thenAnswer(
      (_) async => const Right([
        WishlistItem(productId: 1, title: 'Essence Mascara', thumbnail: 't', price: 10),
      ]),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));

    verify(
      () => toggleWishlist(
        const ToggleWishlistParams(
          productId: 1,
          title: 'Essence Mascara',
          thumbnail: 'https://example.com/thumb.png',
          price: 10,
        ),
      ),
    ).called(1);
  });
}
