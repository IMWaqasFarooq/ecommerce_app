import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import 'search_providers.dart';
import 'search_state.dart';

part 'search_notifier.g.dart';

const _debounceDuration = Duration(milliseconds: 400);

@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounce;

  @override
  SearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return SearchState(history: ref.watch(searchHistoryRepositoryProvider).getHistory());
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      state = state.copyWith(status: SearchStatus.idle, results: []);
      return;
    }

    _debounce = Timer(_debounceDuration, () => _search(query));
  }

  Future<void> submit(String query) async {
    _debounce?.cancel();
    state = state.copyWith(query: query);
    await _search(query);
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    state = state.copyWith(status: SearchStatus.loading);

    final result = await ref.read(searchProductsUseCaseProvider)(query.trim());
    await result.fold(
      (failure) async => state = state.copyWith(status: SearchStatus.failure, failure: failure),
      (products) async {
        await ref.read(searchHistoryRepositoryProvider).addQuery(query.trim());
        await ref.read(analyticsServiceProvider).logSearch(query.trim());
        state = state.copyWith(
          status: SearchStatus.success,
          results: products,
          history: ref.read(searchHistoryRepositoryProvider).getHistory(),
          failure: null,
        );
      },
    );
  }

  void removeHistoryEntry(String query) {
    ref.read(searchHistoryRepositoryProvider).removeQuery(query);
    state = state.copyWith(history: ref.read(searchHistoryRepositoryProvider).getHistory());
  }

  void clearHistory() {
    ref.read(searchHistoryRepositoryProvider).clearHistory();
    state = state.copyWith(history: const []);
  }
}
