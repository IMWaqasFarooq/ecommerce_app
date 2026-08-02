import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/entities/product_sort.dart';
import '../providers/home_providers.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/product_horizontal_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _openProduct(BuildContext context, Product product) {
    context.push(RoutePaths.productDetailPath(product.id.toString()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bannersAsync = ref.watch(discountBannersProvider);
    final spotlightsAsync = ref.watch(categorySpotlightsProvider);
    final trendingAsync = ref.watch(trendingProductsProvider);
    final youMayLikeAsync = ref.watch(youMayLikeProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Velora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(RoutePaths.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeProductPoolProvider);
          await ref.read(homeProductPoolProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            const SizedBox(height: AppSpacing.sm),
            bannersAsync.when(
              data: (banners) => BannerCarousel(
                banners: banners,
                onTap: (banner) =>
                    context.push(RoutePaths.productsPath(category: banner.category)),
              ),
              loading: () =>
                  const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            trendingAsync.when(
              data: (products) => ProductHorizontalSection(
                title: l10n.trendingSectionTitle,
                products: products,
                onViewMore: () =>
                    context.push(RoutePaths.productsPath(sort: ProductSort.ratingHighToLow)),
                onProductTap: (product) => _openProduct(context, product),
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            spotlightsAsync.when(
              data: (spotlights) => Column(
                children: [
                  for (final spotlight in spotlights)
                    ProductHorizontalSection(
                      title: spotlight.label,
                      products: spotlight.products,
                      onViewMore: () =>
                          context.push(RoutePaths.productsPath(category: spotlight.category)),
                      onProductTap: (product) => _openProduct(context, product),
                    ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            youMayLikeAsync.when(
              data: (products) => ProductHorizontalSection(
                title: l10n.youMayLikeSectionTitle,
                products: products,
                onViewMore: () => context.push(RoutePaths.products),
                onProductTap: (product) => _openProduct(context, product),
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
