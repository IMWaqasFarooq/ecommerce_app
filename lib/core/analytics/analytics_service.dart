abstract class AnalyticsService {
  Future<void> logSignUp(String method);
  Future<void> logLogin(String method);
  Future<void> logSearch(String query);
  Future<void> logViewProduct({
    required int productId,
    required String name,
    required double price,
  });
  Future<void> logAddToCart({required int productId, required String name, required double price});
  Future<void> logBeginCheckout({required double value});
  Future<void> logPurchase({required String orderId, required double value});
  Future<void> setUserId(String? userId);
}
