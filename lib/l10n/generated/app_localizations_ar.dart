// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get required => 'مطلوب';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInSubtitle => 'سجّل الدخول للمتابعة إلى Velora';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get enterValidEmail => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get atLeast6Characters => '6 أحرف على الأقل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get orDivider => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get continueWithApple => 'المتابعة باستخدام Apple';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get enterEmailAboveFirst => 'أدخل بريدك الإلكتروني أعلاه أولاً';

  @override
  String passwordResetEmailSent(String email) {
    return 'تم إرسال رابط إعادة تعيين كلمة المرور إلى $email';
  }

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get searchProductsHint => 'ابحث عن المنتجات';

  @override
  String get categoryAll => 'الكل';

  @override
  String get noProductsMatchFilters => 'لا توجد منتجات تطابق عوامل التصفية';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get failedToLoadProduct => 'تعذر تحميل المنتج';

  @override
  String inStockWithCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'متوفر ($countString)';
  }

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get descriptionSectionTitle => 'الوصف';

  @override
  String reviewsSectionTitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'التقييمات ($countString)';
  }

  @override
  String get youMightAlsoLike => 'قد يعجبك أيضًا';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get addedToCart => 'تمت الإضافة إلى السلة';

  @override
  String get sortLabel => 'ترتيب';

  @override
  String get filterLabel => 'تصفية';

  @override
  String get sortByTitle => 'ترتيب حسب';

  @override
  String get filterTitle => 'تصفية';

  @override
  String get priceLabel => 'السعر';

  @override
  String get minLabel => 'الأدنى';

  @override
  String get maxLabel => 'الأقصى';

  @override
  String get minimumRating => 'التقييم الأدنى';

  @override
  String get inStockOnly => 'المتوفر فقط';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get apply => 'تطبيق';

  @override
  String get sortFeatured => 'المميزة';

  @override
  String get sortPriceLowToHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get sortPriceHighToLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get sortRatingHighToLow => 'التقييم: من الأعلى إلى الأقل';

  @override
  String get sortNameAZ => 'الاسم: أ إلى ي';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearButton => 'مسح';

  @override
  String get searchEmptyPrompt =>
      'ابحث عن المنتجات بالاسم أو العلامة التجارية أو الفئة';

  @override
  String get cartTitle => 'السلة';

  @override
  String get failedToLoadCart => 'تعذر تحميل السلة';

  @override
  String get cartEmpty => 'سلتك فارغة';

  @override
  String get subtotalLabel => 'المجموع الفرعي';

  @override
  String get discountLabel => 'الخصم';

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get proceedToCheckout => 'المتابعة إلى الدفع';

  @override
  String get couponCodeHint => 'رمز الخصم';

  @override
  String get wishlistTitle => 'المفضلة';

  @override
  String get failedToLoadWishlist => 'تعذر تحميل قائمة المفضلة';

  @override
  String get wishlistEmpty => 'قائمة المفضلة فارغة';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get failedToLoadCheckout => 'تعذر تحميل صفحة الدفع';

  @override
  String get shippingAddressTitle => 'عنوان الشحن';

  @override
  String get noSavedAddresses => 'لا توجد عناوين محفوظة بعد';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get continueToShipping => 'المتابعة إلى الشحن';

  @override
  String get shippingMethodTitle => 'طريقة الشحن';

  @override
  String businessDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString يوم عمل',
      many: '$countString يوم عمل',
      few: '$countString أيام عمل',
      two: 'يومي عمل',
      one: 'يوم عمل واحد',
      zero: 'لا أيام عمل',
    );
    return '$_temp0';
  }

  @override
  String get backButton => 'رجوع';

  @override
  String get orderSummaryTitle => 'ملخص الطلب';

  @override
  String shippingWithMethod(String method) {
    return 'الشحن ($method)';
  }

  @override
  String get placeOrder => 'تأكيد الطلب';

  @override
  String get payWithTitle => 'الدفع باستخدام';

  @override
  String get paymentMethodCard => 'بطاقة خصم/ائتمان';

  @override
  String get paymentMethodCashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get changeAddressAction => 'تغيير';

  @override
  String get slideToPlaceOrder => 'اسحب لتأكيد الطلب';

  @override
  String itemsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عنصر',
      many: '$countString عنصرًا',
      few: '$countString عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get newAddressTitle => 'عنوان جديد';

  @override
  String get addressLineLabel => 'العنوان';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get stateLabel => 'المحافظة';

  @override
  String get postalCodeLabel => 'الرمز البريدي';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get myAddressesTitle => 'عناويني';

  @override
  String get failedToLoadAddresses => 'تعذر تحميل العناوين';

  @override
  String get addAddressButton => 'إضافة عنوان';

  @override
  String get shippingStandard => 'شحن عادي';

  @override
  String get shippingExpress => 'شحن سريع';

  @override
  String get shippingOvernight => 'شحن فوري (خلال يوم)';

  @override
  String get orderNotFound => 'الطلب غير موجود';

  @override
  String get orderPlaced => 'تم تقديم الطلب!';

  @override
  String orderNumberWithTotal(String id, String total) {
    return 'الطلب رقم $id · $total';
  }

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get myOrdersTitle => 'طلباتي';

  @override
  String get failedToLoadOrders => 'تعذر تحميل الطلبات';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String orderNumberLabel(String id) {
    return 'الطلب رقم $id';
  }

  @override
  String get orderDetailsTitle => 'تفاصيل الطلب';

  @override
  String get itemsSectionTitle => 'العناصر';

  @override
  String get shippingAddressSectionTitle => 'عنوان الشحن';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get orderCancelledMessage => 'تم إلغاء هذا الطلب';

  @override
  String get statusProcessing => 'قيد المعالجة';

  @override
  String get statusShipped => 'تم الشحن';

  @override
  String get statusDelivered => 'تم التوصيل';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get accountSection => 'الحساب';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get myAddresses => 'عناويني';

  @override
  String get wishlist => 'المفضلة';

  @override
  String get preferencesSection => 'التفضيلات';

  @override
  String get themeLabel => 'المظهر';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get pushNotifications => 'الإشعارات';

  @override
  String get supportSection => 'الدعم';

  @override
  String get aboutLabel => 'حول التطبيق';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get saveButton => 'حفظ';

  @override
  String get themeSystemDefault => 'افتراضي النظام';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get aboutAppDescription =>
      'تطبيق تسوق إلكتروني تجريبي مبني باستخدام Flutter وRiverpod وFirebase وStripe.';

  @override
  String versionLabel(String version, String buildNumber) {
    return 'الإصدار $version ($buildNumber)';
  }

  @override
  String get navShop => 'المتجر';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorNetworkTimeout => 'انتهت مهلة الطلب';

  @override
  String get errorNetworkInsecureConnection => 'تم رفض الاتصال غير الآمن';

  @override
  String get errorNetworkNoCachedData =>
      'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزّنة';

  @override
  String get errorCache => 'خطأ في التخزين المحلي';

  @override
  String get errorSessionExpired => 'انتهت صلاحية الجلسة';

  @override
  String get errorRequestCancelled => 'تم إلغاء الطلب';

  @override
  String get errorRateLimitExceeded =>
      'طلبات كثيرة جدًا، الرجاء المحاولة لاحقًا';

  @override
  String get errorServerUnavailable => 'الخادم غير متاح حاليًا';

  @override
  String get errorServer => 'خطأ في الخادم';

  @override
  String get errorValidationNameRequired => 'أدخل اسمك';

  @override
  String get errorValidationEmailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get errorValidationPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get errorValidationInvalidCoupon => 'رمز الخصم غير صالح';

  @override
  String get errorValidationOrderNotCancellable =>
      'يمكن إلغاء الطلبات قيد المعالجة فقط';

  @override
  String get errorPaymentCancelled => 'تم إلغاء عملية الدفع';

  @override
  String get errorPaymentFailed => 'فشلت عملية الدفع، الرجاء المحاولة مرة أخرى';

  @override
  String get errorAuthCancelled => 'تم إلغاء تسجيل الدخول';

  @override
  String get errorAuthGoogleFailed =>
      'فشل تسجيل الدخول عبر Google، الرجاء المحاولة مرة أخرى';

  @override
  String get errorAuthAppleFailed =>
      'فشل تسجيل الدخول عبر Apple، الرجاء المحاولة مرة أخرى';

  @override
  String get errorAuthUserNotFound =>
      'لم يتم العثور على حساب بهذا البريد الإلكتروني';

  @override
  String get errorAuthWrongPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errorAuthEmailInUse => 'يوجد حساب بالفعل بهذا البريد الإلكتروني';

  @override
  String get errorAuthWeakPassword => 'اختر كلمة مرور أقوى';

  @override
  String get errorAuthUserDisabled => 'تم تعطيل هذا الحساب';

  @override
  String get errorAuthTooManyRequests =>
      'محاولات كثيرة جدًا، الرجاء المحاولة لاحقًا';

  @override
  String get errorAuthNetworkRequestFailed => 'خطأ في الشبكة، تحقق من اتصالك';

  @override
  String get errorAuthGeneric => 'فشلت عملية المصادقة';

  @override
  String get unknownUser => 'غير معروف';
}
