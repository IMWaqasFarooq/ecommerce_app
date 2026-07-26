import 'package:hive/hive.dart';

const _historyKey = 'queries';
const _maxHistory = 10;

abstract class SearchHistoryLocalDataSource {
  List<String> getHistory();
  Future<void> addQuery(String query);
  Future<void> removeQuery(String query);
  Future<void> clearHistory();
}

class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  SearchHistoryLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  List<String> getHistory() {
    final raw = _box.get(_historyKey) as List<dynamic>?;
    return raw?.cast<String>() ?? const [];
  }

  @override
  Future<void> addQuery(String query) {
    final current = getHistory().where((q) => q != query).toList();
    final updated = [query, ...current].take(_maxHistory).toList();
    return _box.put(_historyKey, updated);
  }

  @override
  Future<void> removeQuery(String query) {
    final updated = getHistory().where((q) => q != query).toList();
    return _box.put(_historyKey, updated);
  }

  @override
  Future<void> clearHistory() => _box.delete(_historyKey);
}
