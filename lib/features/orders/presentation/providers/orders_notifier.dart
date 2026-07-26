import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/order.dart';
import 'order_providers.dart';

part 'orders_notifier.g.dart';

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  @override
  Future<List<Order>> build() async {
    final result = await ref.watch(getOrdersUseCaseProvider)(const NoParams());
    return result.fold((failure) => throw failure, (orders) => orders);
  }

  Future<Failure?> cancelOrder(String id) async {
    final result = await ref.read(cancelOrderUseCaseProvider)(id);
    return result.fold((failure) => failure, (cancelled) {
      final current = state.value ?? [];
      state = AsyncData([for (final order in current) order.id == id ? cancelled : order]);
      return null;
    });
  }
}
