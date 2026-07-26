import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigService {
  Future<void> initialize();
  bool get couponsEnabled;
  bool get wishlistEnabled;
}

class RemoteConfigServiceImpl implements RemoteConfigService {
  RemoteConfigServiceImpl(this._remoteConfig);
  final FirebaseRemoteConfig _remoteConfig;

  static const _defaults = <String, dynamic>{
    'coupons_enabled': true,
    'wishlist_enabled': true,
  };

  @override
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _remoteConfig.setDefaults(_defaults);
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      return;
    }
  }

  @override
  bool get couponsEnabled => _remoteConfig.getBool('coupons_enabled');

  @override
  bool get wishlistEnabled => _remoteConfig.getBool('wishlist_enabled');
}
