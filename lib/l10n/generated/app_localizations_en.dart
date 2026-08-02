// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get required => 'Required';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to continue to Velora';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get atLeast6Characters => 'At least 6 characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get orDivider => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get enterEmailAboveFirst => 'Enter your email above first';

  @override
  String passwordResetEmailSent(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String get createAccount => 'Create account';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get searchProductsHint => 'Search products';

  @override
  String get categoryAll => 'All';

  @override
  String get noProductsMatchFilters => 'No products match your filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get failedToLoadProduct => 'Failed to load product';

  @override
  String inStockWithCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'In stock ($countString)';
  }

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get descriptionSectionTitle => 'Description';

  @override
  String reviewsSectionTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Reviews ($countString)';
  }

  @override
  String get youMightAlsoLike => 'You might also like';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get sortLabel => 'Sort';

  @override
  String get filterLabel => 'Filter';

  @override
  String get sortByTitle => 'Sort by';

  @override
  String get filterTitle => 'Filter';

  @override
  String get priceLabel => 'Price';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get inStockOnly => 'In stock only';

  @override
  String get clearAll => 'Clear all';

  @override
  String get apply => 'Apply';

  @override
  String get sortFeatured => 'Featured';

  @override
  String get sortPriceLowToHigh => 'Price: Low to High';

  @override
  String get sortPriceHighToLow => 'Price: High to Low';

  @override
  String get sortRatingHighToLow => 'Rating: High to Low';

  @override
  String get sortNameAZ => 'Name: A to Z';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearButton => 'Clear';

  @override
  String get searchEmptyPrompt =>
      'Search for products by name, brand, or category';

  @override
  String get cartTitle => 'Cart';

  @override
  String get failedToLoadCart => 'Failed to load cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get discountLabel => 'Discount';

  @override
  String get totalLabel => 'Total';

  @override
  String get proceedToCheckout => 'Proceed to checkout';

  @override
  String get couponCodeHint => 'Coupon code';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get failedToLoadWishlist => 'Failed to load wishlist';

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get failedToLoadCheckout => 'Failed to load checkout';

  @override
  String get shippingAddressTitle => 'Shipping address';

  @override
  String get noSavedAddresses => 'No saved addresses yet';

  @override
  String get addNewAddress => 'Add new address';

  @override
  String get continueToShipping => 'Continue to shipping';

  @override
  String get shippingMethodTitle => 'Shipping method';

  @override
  String businessDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString business days',
      one: '$countString business day',
    );
    return '$_temp0';
  }

  @override
  String get backButton => 'Back';

  @override
  String get orderSummaryTitle => 'Order summary';

  @override
  String shippingWithMethod(String method) {
    return 'Shipping ($method)';
  }

  @override
  String get placeOrder => 'Place order';

  @override
  String get payWithTitle => 'Pay with';

  @override
  String get paymentMethodCard => 'Debit/Credit Card';

  @override
  String get paymentMethodCashOnDelivery => 'Cash on Delivery';

  @override
  String get changeAddressAction => 'Change';

  @override
  String get slideToPlaceOrder => 'Slide to place order';

  @override
  String itemsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '$countString item',
    );
    return '$_temp0';
  }

  @override
  String get phoneLabel => 'Phone';

  @override
  String get saveAddress => 'Save address';

  @override
  String get myAddressesTitle => 'My addresses';

  @override
  String get failedToLoadAddresses => 'Failed to load addresses';

  @override
  String get addAddressButton => 'Add address';

  @override
  String get addressTypeHome => 'Home';

  @override
  String get addressTypeWork => 'Work';

  @override
  String get addressTypeOther => 'Other';

  @override
  String get searchAddressHint => 'Search for your building, area...';

  @override
  String get currentLocationAction => 'Current location';

  @override
  String get deliveredHereLabel => 'Your order will be delivered here';

  @override
  String pinDistanceWarning(String distance) {
    return 'Pin is $distance away from your current location';
  }

  @override
  String get addAddressDetailsAction => 'Add address details';

  @override
  String get addressDetailsTitle => 'Address Details';

  @override
  String get editAction => 'Edit';

  @override
  String get addAddressMethodTitle => 'Add address';

  @override
  String get chooseFromMapAction => 'Choose from map';

  @override
  String get enterManuallyAction => 'Enter manually';

  @override
  String get streetAreaLabel => 'Street / Area';

  @override
  String get apartmentVillaLabel => 'Apt & Floor No. / Villa No.';

  @override
  String get buildingClusterLabel => 'Building / Cluster name';

  @override
  String get directionsOptionalLabel => 'Directions to reach (Optional)';

  @override
  String get nicknameOptionalLabel => 'Address nickname (Optional)';

  @override
  String get receiverDetailsLabel => 'Receiver details for this address';

  @override
  String distanceMeters(String value) {
    return '$value m';
  }

  @override
  String distanceKilometers(String value) {
    return '$value km';
  }

  @override
  String get mapNotConfiguredTitle => 'Map picker not configured';

  @override
  String get mapNotConfiguredMessage =>
      'Add a Google Maps API key to enable picking a delivery address on the map.';

  @override
  String get locationUnavailableMessage =>
      'Couldn\'t get your current location';

  @override
  String get shippingStandard => 'Standard shipping';

  @override
  String get shippingExpress => 'Express shipping';

  @override
  String get shippingOvernight => 'Overnight shipping';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get orderPlaced => 'Order placed!';

  @override
  String orderNumberWithTotal(String id, String total) {
    return 'Order #$id · $total';
  }

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get myOrdersTitle => 'My orders';

  @override
  String get failedToLoadOrders => 'Failed to load orders';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String orderNumberLabel(String id) {
    return 'Order #$id';
  }

  @override
  String get orderDetailsTitle => 'Order details';

  @override
  String get itemsSectionTitle => 'Items';

  @override
  String get shippingAddressSectionTitle => 'Shipping address';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get orderCancelledMessage => 'This order was cancelled';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get accountSection => 'Account';

  @override
  String get myOrders => 'My orders';

  @override
  String get myAddresses => 'My addresses';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get themeLabel => 'Theme';

  @override
  String get languageLabel => 'Language';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get supportSection => 'Support';

  @override
  String get aboutLabel => 'About';

  @override
  String get logOut => 'Log out';

  @override
  String get saveButton => 'Save';

  @override
  String get themeSystemDefault => 'System default';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get aboutAppDescription =>
      'A portfolio e-commerce app built with Flutter, Riverpod, Firebase, and Stripe.';

  @override
  String versionLabel(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get navShop => 'Shop';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorNetworkTimeout => 'The request timed out';

  @override
  String get errorNetworkInsecureConnection => 'Insecure connection rejected';

  @override
  String get errorNetworkNoCachedData =>
      'No internet connection and no cached data';

  @override
  String get errorCache => 'Local cache error';

  @override
  String get errorSessionExpired => 'Session expired';

  @override
  String get errorRequestCancelled => 'Request cancelled';

  @override
  String get errorRateLimitExceeded => 'Too many requests, please slow down';

  @override
  String get errorServerUnavailable => 'Server is currently unavailable';

  @override
  String get errorServer => 'Server error';

  @override
  String get errorValidationNameRequired => 'Enter your name';

  @override
  String get errorValidationEmailInvalid => 'Enter a valid email address';

  @override
  String get errorValidationPasswordTooShort =>
      'Password must be at least 6 characters';

  @override
  String get errorValidationInvalidCoupon => 'Invalid coupon code';

  @override
  String get errorValidationOrderNotCancellable =>
      'Only processing orders can be cancelled';

  @override
  String get errorPaymentCancelled => 'Payment was cancelled';

  @override
  String get errorPaymentFailed => 'Payment failed, please try again';

  @override
  String get errorAuthCancelled => 'Sign-in cancelled';

  @override
  String get errorAuthGoogleFailed => 'Google sign-in failed, please try again';

  @override
  String get errorAuthAppleFailed => 'Apple sign-in failed, please try again';

  @override
  String get errorAuthUserNotFound => 'No account found for that email';

  @override
  String get errorAuthWrongPassword => 'Incorrect email or password';

  @override
  String get errorAuthEmailInUse => 'An account already exists for that email';

  @override
  String get errorAuthWeakPassword => 'Choose a stronger password';

  @override
  String get errorAuthUserDisabled => 'This account has been disabled';

  @override
  String get errorAuthTooManyRequests =>
      'Too many attempts, please try again later';

  @override
  String get errorAuthNetworkRequestFailed =>
      'Network error, check your connection';

  @override
  String get errorAuthGeneric => 'Authentication failed';

  @override
  String get unknownUser => 'Unknown';
}
