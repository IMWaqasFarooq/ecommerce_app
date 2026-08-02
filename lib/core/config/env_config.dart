import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor.dart';

class EnvConfig {
  EnvConfig(this.flavor);

  final Flavor flavor;

  Future<void> load() => dotenv.load(fileName: flavor.envFileName);

  String get apiBaseUrl => _read('API_BASE_URL');

  String get stripePublishableKey => _read('STRIPE_PUBLISHABLE_KEY');

  String get paymentsFunctionUrl => _read('PAYMENTS_FUNCTION_URL');

  // Optional: the map picker degrades to a friendly "not configured" state
  // instead of crashing the whole app when this hasn't been provisioned yet.
  String get googleMapsApiKey => dotenv.maybeGet('GOOGLE_MAPS_API_KEY') ?? '';

  int get maxRetries => _readInt('NETWORK_MAX_RETRIES', fallback: 3);

  Duration get retryBaseDelay =>
      Duration(milliseconds: _readInt('NETWORK_RETRY_BASE_DELAY_MS', fallback: 500));

  Duration get connectTimeout =>
      Duration(milliseconds: _readInt('NETWORK_CONNECT_TIMEOUT_MS', fallback: 15000));

  Duration get receiveTimeout =>
      Duration(milliseconds: _readInt('NETWORK_RECEIVE_TIMEOUT_MS', fallback: 15000));

  bool get enableNetworkLogging =>
      _readBool('ENABLE_NETWORK_LOGGING', fallback: !flavor.isProduction);

  String _read(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required env key "$key" in ${flavor.envFileName}. '
        'Copy assets/env/.env.example and fill it in.',
      );
    }
    return value;
  }

  int _readInt(String key, {required int fallback}) {
    final raw = dotenv.maybeGet(key);
    if (raw == null || raw.isEmpty) return fallback;
    return int.tryParse(raw) ?? fallback;
  }

  bool _readBool(String key, {required bool fallback}) {
    final raw = dotenv.maybeGet(key);
    if (raw == null || raw.isEmpty) return fallback;
    return raw.toLowerCase() == 'true';
  }
}
