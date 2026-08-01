abstract final class RoutePaths {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/';
  static const productDetail = '/product/:productId';
  static const search = '/search';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
  static const checkout = '/checkout';
  static const orderConfirmation = '/checkout/confirmation/:orderId';
  static const orders = '/orders';
  static const orderDetail = '/orders/:orderId';
  static const profile = '/profile';
  static const addresses = '/profile/addresses';
  static const about = '/profile/about';

  static String productDetailPath(String productId) => '/product/$productId';
  static String orderConfirmationPath(String orderId) => '/checkout/confirmation/$orderId';
  static String orderDetailPath(String orderId) => '/orders/$orderId';
}

abstract final class RouteNames {
  static const splash = 'splash';
  static const login = 'login';
  static const signup = 'signup';
  static const home = 'home';
  static const productDetail = 'productDetail';
  static const search = 'search';
  static const cart = 'cart';
  static const wishlist = 'wishlist';
  static const checkout = 'checkout';
  static const orderConfirmation = 'orderConfirmation';
  static const orders = 'orders';
  static const orderDetail = 'orderDetail';
  static const profile = 'profile';
  static const addresses = 'addresses';
  static const about = 'about';
}
