import 'package:hive/hive.dart';

import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  List<OrderModel> getOrders(String ownerKey);
  Future<void> saveOrders(String ownerKey, List<OrderModel> orders);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  OrderLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  List<OrderModel> getOrders(String ownerKey) {
    final raw = _box.get(ownerKey) as List<dynamic>?;
    if (raw == null) return const [];
    return raw.map((json) => OrderModel.fromJson(Map<String, dynamic>.from(json as Map))).toList();
  }

  @override
  Future<void> saveOrders(String ownerKey, List<OrderModel> orders) {
    return _box.put(ownerKey, orders.map((o) => o.toJson()).toList());
  }
}
