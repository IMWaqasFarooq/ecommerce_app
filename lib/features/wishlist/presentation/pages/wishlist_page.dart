import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/wishlist_notifier.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load wishlist')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Your wishlist is empty'));
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
                title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                  onPressed: () => ref.read(wishlistProvider.notifier).toggle(
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
