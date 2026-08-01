import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../../categories/presentation/widgets/category_chip.dart';
import '../../domain/entities/product_filter.dart';
import '../providers/product_list_notifier.dart';
import '../providers/product_list_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';
import '../widgets/skeleton_product_grid.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/sort_filter_pill.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      ref.read(productListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(productListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

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
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: categoriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
              data: (categories) => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  CategoryChip(
                    label: l10n.categoryAll,
                    translate: false,
                    selected: state.selectedCategory == null,
                    onTap: () => ref.read(productListProvider.notifier).selectCategory(null),
                  ),
                  for (final category in categories)
                    CategoryChip(
                      label: category.name,
                      selected: state.selectedCategory == category.slug,
                      onTap: () =>
                          ref.read(productListProvider.notifier).selectCategory(category.slug),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SortFilterPill(
        filterActive: state.filter.isActive,
        onSort: () async {
          final sort = await showSortBottomSheet(context, state.sort);
          if (sort != null) await ref.read(productListProvider.notifier).changeSort(sort);
        },
        onFilter: () async {
          final filter = await showFilterBottomSheet(context, state.filter);
          if (filter != null) ref.read(productListProvider.notifier).applyFilter(filter);
        },
      ),
    );
  }

  Widget _buildBody(ProductListState state) {
    final l10n = AppLocalizations.of(context);
    if (state.status == ProductListStatus.loading) {
      return const SkeletonProductGrid();
    }

    if (state.status == ProductListStatus.failure && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.failure?.localizedMessage(context) ?? l10n.somethingWentWrong),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: () => ref.read(productListProvider.notifier).refresh(),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final displayedProducts = state.displayedProducts;

    if (displayedProducts.isEmpty && state.filter.isActive) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.noProductsMatchFilters),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () =>
                  ref.read(productListProvider.notifier).applyFilter(ProductFilter.empty),
              child: Text(l10n.clearFilters),
            ),
          ],
        ),
      );
    }

    if (displayedProducts.isEmpty) {
      return Center(child: Text(l10n.noProductsFound));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(productListProvider.notifier).refresh(),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xxl + AppSpacing.lg,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.62,
        ),
        itemCount: displayedProducts.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= displayedProducts.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = displayedProducts[index];
          return ProductCard(
            product: product,
            onTap: () => context.push(RoutePaths.productDetailPath(product.id.toString())),
          );
        },
      ),
    );
  }
}
