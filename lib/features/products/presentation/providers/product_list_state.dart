import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';

part 'product_list_state.freezed.dart';

enum ProductListStatus { initial, loading, success, failure }

@freezed
abstract class ProductListState with _$ProductListState {
  const factory ProductListState({
    @Default(ProductListStatus.initial) ProductListStatus status,
    @Default(<Product>[]) List<Product> products,
    @Default(1) int currentPage,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? failure,
    String? selectedCategory,
  }) = _ProductListState;
}
