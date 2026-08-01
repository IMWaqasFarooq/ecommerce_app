import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_filter.dart';
import '../../domain/entities/product_sort.dart';

part 'product_list_state.freezed.dart';

enum ProductListStatus { initial, loading, success, failure }

@freezed
abstract class ProductListState with _$ProductListState {
  const ProductListState._();

  const factory ProductListState({
    @Default(ProductListStatus.initial) ProductListStatus status,
    @Default(<Product>[]) List<Product> products,
    @Default(1) int currentPage,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? failure,
    String? selectedCategory,
    @Default(ProductSort.featured) ProductSort sort,
    @Default(ProductFilter.empty) ProductFilter filter,
  }) = _ProductListState;

  List<Product> get displayedProducts =>
      filter.isActive ? products.where(filter.matches).toList() : products;
}
