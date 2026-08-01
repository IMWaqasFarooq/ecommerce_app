import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product_filter.dart';
import '../../domain/entities/product_sort.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_list_state.dart';
import 'product_providers.dart';

part 'product_list_notifier.g.dart';

const _perPage = 20;

@Riverpod(keepAlive: true)
class ProductListNotifier extends _$ProductListNotifier {
  @override
  ProductListState build() {
    Future.microtask(refresh);
    return const ProductListState();
  }

  Future<void> refresh() => _load(page: 1);

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.status != ProductListStatus.success) return;
    state = state.copyWith(isLoadingMore: true);
    await _load(page: state.currentPage + 1, append: true);
  }

  Future<void> selectCategory(String? category) async {
    state = state.copyWith(selectedCategory: category);
    await _load(page: 1);
  }

  Future<void> changeSort(ProductSort sort) async {
    if (sort == state.sort) return;
    state = state.copyWith(sort: sort);
    await _load(page: 1);
  }

  void applyFilter(ProductFilter filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> _load({required int page, bool append = false}) async {
    if (!append) state = state.copyWith(status: ProductListStatus.loading);

    final category = state.selectedCategory;
    if (category == null) {
      final result = await ref.read(getProductsUseCaseProvider)(
        GetProductsParams(page: page, limit: _perPage, sort: state.sort),
      );
      result.fold(
        (failure) => state = state.copyWith(
          status: ProductListStatus.failure,
          failure: failure,
          isLoadingMore: false,
        ),
        (data) => state = state.copyWith(
          status: ProductListStatus.success,
          products: append ? [...state.products, ...data.products] : data.products,
          currentPage: page,
          hasMore: data.products.length >= _perPage,
          isLoadingMore: false,
          failure: null,
        ),
      );
    } else {
      final result = await ref.read(getProductsByCategoryUseCaseProvider)(
        GetProductsByCategoryParams(category: category, sort: state.sort),
      );
      result.fold(
        (failure) => state = state.copyWith(
          status: ProductListStatus.failure,
          failure: failure,
          isLoadingMore: false,
        ),
        (products) => state = state.copyWith(
          status: ProductListStatus.success,
          products: products,
          currentPage: 1,
          hasMore: false,
          isLoadingMore: false,
          failure: null,
        ),
      );
    }
  }
}
