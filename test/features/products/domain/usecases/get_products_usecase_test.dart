import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late _MockProductRepository repository;
  late GetProductsUseCase useCase;

  setUp(() {
    repository = _MockProductRepository();
    useCase = GetProductsUseCase(repository);
  });

  const product = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    description: 'A mascara',
    category: 'beauty',
    price: 9.99,
    discountPercentage: 7.17,
    rating: 4.94,
    stock: 5,
    brand: 'Essence',
    thumbnail: 'https://example.com/thumb.png',
    images: ['https://example.com/thumb.png'],
    availabilityStatus: 'In Stock',
    reviews: <ProductReview>[],
  );

  test('fetches the requested page from the repository', () async {
    when(
      () => repository.getProducts(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const Right((products: [product], total: 194)));

    final result = await useCase(const GetProductsParams(page: 2, limit: 20));

    expect(
      result,
      const Right<Failure, ({List<Product> products, int total})>((
        products: [product],
        total: 194,
      )),
    );
    verify(() => repository.getProducts(page: 2, limit: 20)).called(1);
  });

  test('propagates a failure from the repository', () async {
    when(
      () => repository.getProducts(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const Left(Failure.network()));

    final result = await useCase(const GetProductsParams(page: 1, limit: 20));

    expect(result, const Left<Failure, ({List<Product> products, int total})>(Failure.network()));
  });
}
