import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/usecases/toggle_wishlist_usecase.dart';
import 'wishlist_providers.dart';

part 'wishlist_notifier.g.dart';

@riverpod
class WishlistNotifier extends _$WishlistNotifier {
  @override
  Future<List<WishlistItem>> build() async {
    final result = await ref.watch(getWishlistUseCaseProvider)(const NoParams());
    return result.fold((failure) => throw failure, (items) => items);
  }

  bool contains(int productId) {
    return state.value?.any((item) => item.productId == productId) ?? false;
  }

  Future<void> toggle({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
  }) async {
    final result = await ref.read(toggleWishlistUseCaseProvider)(
      ToggleWishlistParams(productId: productId, title: title, thumbnail: thumbnail, price: price),
    );
    result.fold((failure) {}, (items) => state = AsyncData(items));
  }
}
