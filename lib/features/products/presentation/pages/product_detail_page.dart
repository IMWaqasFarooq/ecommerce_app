import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_review.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/price_tag.dart';
import '../widgets/product_card.dart';
import '../widgets/rating_stars.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({required this.productId, super.key});

  final int productId;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final _pageController = PageController();
  int _imageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Failed to load product')),
        data: (product) => _buildContent(context, product),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final relatedAsync = ref.watch(relatedProductsProvider(product.category, product.id));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 340,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _imageIndex = index),
                    itemCount: product.images.length,
                    itemBuilder: (context, index) => CachedNetworkImage(
                      imageUrl: product.images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (product.images.length > 1)
                  Positioned(
                    bottom: AppSpacing.md,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < product.images.length; i++)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _imageIndex ? Colors.white : Colors.white38,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                product.brand.isNotEmpty ? product.brand : product.category,
                style: AppTextStyles.caption(context),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  RatingStars(rating: product.rating, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    product.inStock ? 'In stock (${product.stock})' : 'Out of stock',
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              PriceTag(product: product, large: true),
              const SizedBox(height: AppSpacing.lg),
              Text('Description', style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: AppSpacing.xs),
              Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              if (product.reviews.isNotEmpty) ...[
                Text('Reviews (${product.reviews.length})', style: AppTextStyles.sectionTitle(context)),
                const SizedBox(height: AppSpacing.xs),
                for (final review in product.reviews) _ReviewTile(review: review),
                const SizedBox(height: AppSpacing.lg),
              ],
              relatedAsync.maybeWhen(
                data: (related) => related.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('You might also like', style: AppTextStyles.sectionTitle(context)),
                          const SizedBox(height: AppSpacing.sm),
                          SizedBox(
                            height: 240,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: related.length,
                              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, index) => SizedBox(
                                width: 150,
                                child: ProductCard(
                                  product: related[index],
                                  onTap: () => context.push('/product/${related[index].id}'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.reviewerName, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: AppSpacing.sm),
              RatingStars(rating: review.rating.toDouble(), size: 14),
              const Spacer(),
              Text(DateFormat.yMMMd().format(review.date), style: AppTextStyles.caption(context)),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(review.comment, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
