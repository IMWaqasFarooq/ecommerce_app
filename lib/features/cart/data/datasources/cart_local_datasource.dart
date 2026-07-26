import 'package:hive/hive.dart';

import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';

abstract class CartLocalDataSource {
  List<CartItemModel> getItems(String ownerKey);
  Future<void> saveItems(String ownerKey, List<CartItemModel> items);
  CouponModel? getCoupon(String ownerKey);
  Future<void> saveCoupon(String ownerKey, CouponModel? coupon);
  Future<void> clear(String ownerKey);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  List<CartItemModel> getItems(String ownerKey) {
    final raw = _box.get('${ownerKey}_items') as List<dynamic>?;
    if (raw == null) return const [];
    return raw.map((json) => CartItemModel.fromJson(Map<String, dynamic>.from(json as Map))).toList();
  }

  @override
  Future<void> saveItems(String ownerKey, List<CartItemModel> items) {
    return _box.put('${ownerKey}_items', items.map((i) => i.toJson()).toList());
  }

  @override
  CouponModel? getCoupon(String ownerKey) {
    final raw = _box.get('${ownerKey}_coupon');
    if (raw == null) return null;
    return CouponModel.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  @override
  Future<void> saveCoupon(String ownerKey, CouponModel? coupon) {
    if (coupon == null) return _box.delete('${ownerKey}_coupon');
    return _box.put('${ownerKey}_coupon', coupon.toJson());
  }

  @override
  Future<void> clear(String ownerKey) async {
    await _box.delete('${ownerKey}_items');
    await _box.delete('${ownerKey}_coupon');
  }
}
