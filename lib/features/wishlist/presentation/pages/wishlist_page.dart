import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/translation/translated_text.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/wishlist_notifier.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wishlistTitle)),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.failedToLoadWishlist)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.wishlistEmpty));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnail,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                title: TranslatedText(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(formatPrice(context, item.price)),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: () => ref
                      .read(wishlistProvider.notifier)
                      .toggle(
                        productId: item.productId,
                        title: item.title,
                        thumbnail: item.thumbnail,
                        price: item.price,
                      ),
                ),
                onTap: () => context.push(RoutePaths.productDetailPath(item.productId.toString())),
              );
            },
          );
        },
      ),
    );
  }
}
