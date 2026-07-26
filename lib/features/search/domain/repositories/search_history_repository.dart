abstract class SearchHistoryRepository {
  List<String> getHistory();
  Future<void> addQuery(String query);
  Future<void> removeQuery(String query);
  Future<void> clearHistory();
}
