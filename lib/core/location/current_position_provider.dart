import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_position_provider.g.dart';

/// The device's current GPS position, or null if location services are off,
/// permission was denied, or the lookup otherwise failed — never throws into
/// the UI, callers should just treat null as "no distance info available".
@riverpod
Future<Position?> currentPosition(Ref ref) async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  } catch (_) {
    return null;
  }
}
