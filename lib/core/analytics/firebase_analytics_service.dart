import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);
  final FirebaseAnalytics _analytics;

  @override
  Future<void> logSignUp(String method) => _analytics.logSignUp(signUpMethod: method);

  @override
  Future<void> logLogin(String method) => _analytics.logLogin(loginMethod: method);

  @override
  Future<void> logSearch(String query) => _analytics.logSearch(searchTerm: query);

  @override
  Future<void> logViewProduct({required int productId, required String name, required double price}) {
    return _analytics.logViewItem(
      currency: 'usd',
      value: price,
      items: [AnalyticsEventItem(itemId: '$productId', itemName: name, price: price)],
    );
  }

  @override
  Future<void> logAddToCart({required int productId, required String name, required double price}) {
    return _analytics.logAddToCart(
      currency: 'usd',
      value: price,
      items: [AnalyticsEventItem(itemId: '$productId', itemName: name, price: price)],
    );
  }

  @override
  Future<void> logBeginCheckout({required double value}) {
    return _analytics.logBeginCheckout(currency: 'usd', value: value);
  }

  @override
  Future<void> logPurchase({required String orderId, required double value}) {
    return _analytics.logPurchase(currency: 'usd', value: value, transactionId: orderId);
  }

  @override
  Future<void> setUserId(String? userId) => _analytics.setUserId(id: userId);
}
