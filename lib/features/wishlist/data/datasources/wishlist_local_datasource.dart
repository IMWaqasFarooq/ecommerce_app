import 'package:hive/hive.dart';

import '../models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  List<WishlistItemModel> getItems(String ownerKey);
  Future<void> saveItems(String ownerKey, List<WishlistItemModel> items);
  Future<void> clear(String ownerKey);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  WishlistLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  List<WishlistItemModel> getItems(String ownerKey) {
    final raw = _box.get(ownerKey) as List<dynamic>?;
    if (raw == null) return const [];
    return raw.map((json) => WishlistItemModel.fromJson(Map<String, dynamic>.from(json as Map))).toList();
  }

  @override
  Future<void> saveItems(String ownerKey, List<WishlistItemModel> items) {
    return _box.put(ownerKey, items.map((i) => i.toJson()).toList());
  }

  @override
  Future<void> clear(String ownerKey) => _box.delete(ownerKey);
}
