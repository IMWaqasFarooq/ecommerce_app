import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../products/presentation/widgets/skeleton_product_grid.dart';
import '../providers/search_notifier.dart';
import '../providers/search_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Search products', border: InputBorder.none),
          textInputAction: TextInputAction.search,
          onChanged: notifier.onQueryChanged,
          onSubmitted: notifier.submit,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _controller.clear();
                notifier.onQueryChanged('');
              },
            ),
        ],
      ),
      body: _buildBody(context, state, notifier),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state, SearchNotifier notifier) {
    if (state.query.trim().isEmpty) {
      return _buildHistory(context, state, notifier);
    }

    if (state.status == SearchStatus.loading) {
      return const SkeletonProductGrid();
    }

    if (state.status == SearchStatus.failure) {
      return Center(child: Text(state.failure?.message ?? 'Something went wrong'));
    }

    if (state.results.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      ),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final product = state.results[index];
        return ProductCard(
          product: product,
          onTap: () => context.push(RoutePaths.productDetailPath(product.id.toString())),
        );
      },
    );
  }

  Widget _buildHistory(BuildContext context, SearchState state, SearchNotifier notifier) {
    if (state.history.isEmpty) {
      return const Center(child: Text('Search for products by name, brand, or category'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent searches', style: Theme.of(context).textTheme.titleSmall),
              TextButton(onPressed: notifier.clearHistory, child: const Text('Clear')),
            ],
          ),
        ),
        for (final query in state.history)
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: Text(query),
            trailing: IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: () => notifier.removeHistoryEntry(query),
            ),
            onTap: () {
              _controller.text = query;
              notifier.submit(query);
            },
          ),
      ],
    );
  }
}
