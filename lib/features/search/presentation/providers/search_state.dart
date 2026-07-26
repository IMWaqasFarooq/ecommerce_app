import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';

part 'search_state.freezed.dart';

enum SearchStatus { idle, loading, success, failure }

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
    @Default(SearchStatus.idle) SearchStatus status,
    @Default(<Product>[]) List<Product> results,
    @Default(<String>[]) List<String> history,
    Failure? failure,
  }) = _SearchState;
}
