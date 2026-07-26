import '../../domain/repositories/search_history_repository.dart';
import '../datasources/search_history_local_datasource.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  SearchHistoryRepositoryImpl(this._localDataSource);
  final SearchHistoryLocalDataSource _localDataSource;

  @override
  List<String> getHistory() => _localDataSource.getHistory();

  @override
  Future<void> addQuery(String query) => _localDataSource.addQuery(query);

  @override
  Future<void> removeQuery(String query) => _localDataSource.removeQuery(query);

  @override
  Future<void> clearHistory() => _localDataSource.clearHistory();
}
