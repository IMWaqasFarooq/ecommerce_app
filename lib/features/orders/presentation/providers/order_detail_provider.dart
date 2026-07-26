import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/order.dart';
import 'order_providers.dart';

part 'order_detail_provider.g.dart';

@riverpod
Future<Order> orderDetail(Ref ref, String orderId) async {
  final result = await ref.watch(getOrderByIdUseCaseProvider)(orderId);
  return result.fold((failure) => throw failure, (order) => order);
}
