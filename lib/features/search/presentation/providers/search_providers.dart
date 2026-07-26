import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../data/datasources/search_history_local_datasource.dart';
import '../../data/repositories/search_history_repository_impl.dart';
import '../../domain/repositories/search_history_repository.dart';

final searchHistoryLocalDataSourceProvider = Provider<SearchHistoryLocalDataSource>((ref) {
  return SearchHistoryLocalDataSourceImpl(hiveBox(ref, HiveBoxes.searchHistory));
});

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((ref) {
  return SearchHistoryRepositoryImpl(ref.watch(searchHistoryLocalDataSourceProvider));
});
