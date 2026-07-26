import 'package:ecommerce_app/core/analytics/analytics_service.dart';

class FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> logSignUp(String method) async {}

  @override
  Future<void> logLogin(String method) async {}

  @override
  Future<void> logSearch(String query) async {}

  @override
  Future<void> logViewProduct({
    required int productId,
    required String name,
    required double price,
  }) async {}

  @override
  Future<void> logAddToCart({
    required int productId,
    required String name,
    required double price,
  }) async {}

  @override
  Future<void> logBeginCheckout({required double value}) async {}

  @override
  Future<void> logPurchase({required String orderId, required double value}) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}
