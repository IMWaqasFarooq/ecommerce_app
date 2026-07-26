import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../data/datasources/order_local_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';

final orderLocalDataSourceProvider = Provider<OrderLocalDataSource>((ref) {
  return OrderLocalDataSourceImpl(hiveBox(ref, HiveBoxes.orders));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    localDataSource: ref.watch(orderLocalDataSourceProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

final createOrderUseCaseProvider = Provider((ref) => CreateOrderUseCase(ref.watch(orderRepositoryProvider)));
final getOrderByIdUseCaseProvider = Provider((ref) => GetOrderByIdUseCase(ref.watch(orderRepositoryProvider)));
final getOrdersUseCaseProvider = Provider((ref) => GetOrdersUseCase(ref.watch(orderRepositoryProvider)));
final cancelOrderUseCaseProvider = Provider((ref) => CancelOrderUseCase(ref.watch(orderRepositoryProvider)));
