import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/presentation/providers/auth_state_provider.dart';
import '../../features/cart/presentation/providers/cart_notifier.dart';
import '../../features/cart/presentation/providers/cart_providers.dart';
import '../../features/wishlist/presentation/providers/wishlist_notifier.dart';
import '../../features/wishlist/presentation/providers/wishlist_providers.dart';

part 'guest_data_sync_observer.g.dart';

@Riverpod(keepAlive: true)
class GuestDataSyncObserver extends _$GuestDataSyncObserver {
  @override
  void build() {
    ref.listen(authStateProvider, (previous, next) {
      final wasGuest = previous?.value == null;
      final isNowSignedIn = next.value != null;
      if (!wasGuest || !isNowSignedIn) return;

      ref.read(cartRepositoryProvider).mergeGuestCartIntoUser().then((_) {
        ref.invalidate(cartProvider);
      });
      ref.read(wishlistRepositoryProvider).mergeGuestWishlistIntoUser().then((_) {
        ref.invalidate(wishlistProvider);
      });
    });
  }
}
