import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/category.dart';
import 'category_providers.dart';

part 'categories_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Category>> categories(Ref ref) async {
  final result = await ref.watch(getCategoriesUseCaseProvider)(const NoParams());
  return result.fold((failure) => throw failure, (categories) => categories);
}
