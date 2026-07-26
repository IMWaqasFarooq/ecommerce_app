import 'package:hive/hive.dart';

import '../models/address_model.dart';

abstract class AddressLocalDataSource {
  List<AddressModel> getAddresses(String ownerKey);
  Future<void> saveAddresses(String ownerKey, List<AddressModel> addresses);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  AddressLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  @override
  List<AddressModel> getAddresses(String ownerKey) {
    final raw = _box.get('addresses_$ownerKey') as List<dynamic>?;
    if (raw == null) return const [];
    return raw
        .map((json) => AddressModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  @override
  Future<void> saveAddresses(String ownerKey, List<AddressModel> addresses) {
    return _box.put('addresses_$ownerKey', addresses.map((a) => a.toJson()).toList());
  }
}
