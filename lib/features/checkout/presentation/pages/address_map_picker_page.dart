import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/location/current_position_provider.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/address.dart';

/// Data handed off to [AddressDetailsPage] once a location has been picked.
class PickedLocation {
  const PickedLocation({
    this.latitude,
    this.longitude,
    required this.streetArea,
    this.existing,
  });

  final double? latitude;
  final double? longitude;
  final String streetArea;
  final Address? existing;

  bool get isFromMap => latitude != null && longitude != null;
}

const _fallbackCameraTarget = LatLng(25.2048, 55.2708);
const _farPinThresholdMeters = 500;

class AddressMapPickerPage extends ConsumerStatefulWidget {
  const AddressMapPickerPage({this.initial, super.key});

  final Address? initial;

  @override
  ConsumerState<AddressMapPickerPage> createState() => _AddressMapPickerPageState();
}

class _AddressMapPickerPageState extends ConsumerState<AddressMapPickerPage> {
  final _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng _target = _fallbackCameraTarget;
  String? _streetArea;
  bool _resolvingAddress = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    final initialLat = widget.initial?.latitude;
    final initialLng = widget.initial?.longitude;
    if (initialLat != null && initialLng != null) {
      _target = LatLng(initialLat, initialLng);
    }
    _loadCurrentPosition();
  }

  Future<void> _loadCurrentPosition() async {
    final position = await ref.read(currentPositionProvider.future);
    if (!mounted) return;
    setState(() => _currentPosition = position);
    if (widget.initial == null && position != null) {
      final target = LatLng(position.latitude, position.longitude);
      setState(() => _target = target);
      await _mapController?.animateCamera(CameraUpdate.newLatLng(target));
      unawaited(_reverseGeocode(target));
    } else {
      unawaited(_reverseGeocode(_target));
    }
  }

  Future<void> _reverseGeocode(LatLng target) async {
    setState(() => _resolvingAddress = true);
    try {
      final placemarks = await placemarkFromCoordinates(target.latitude, target.longitude);
      final placemark = placemarks.isEmpty ? null : placemarks.first;
      final parts = [
        placemark?.street,
        placemark?.subLocality?.isNotEmpty == true ? placemark?.subLocality : placemark?.locality,
      ].where((p) => p != null && p.isNotEmpty).cast<String>();
      if (!mounted) return;
      setState(() {
        _streetArea = parts.isEmpty ? '${target.latitude}, ${target.longitude}' : parts.join(', ');
        _resolvingAddress = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _resolvingAddress = false);
    }
  }

  Future<void> _goToCurrentLocation() async {
    ref.invalidate(currentPositionProvider);
    final position = await ref.read(currentPositionProvider.future);
    if (!mounted) return;
    if (position == null) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.locationUnavailableMessage)));
      return;
    }
    setState(() => _currentPosition = position);
    final target = LatLng(position.latitude, position.longitude);
    await _mapController?.animateCamera(CameraUpdate.newLatLng(target));
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final locations = await locationFromAddress(query);
      final location = locations.isEmpty ? null : locations.first;
      if (location == null || !mounted) return;
      final target = LatLng(location.latitude, location.longitude);
      await _mapController?.animateCamera(CameraUpdate.newLatLng(target));
    } catch (_) {
      // Ignore unresolvable search queries; the user can keep panning the map.
    }
  }

  double? get _distanceFromCurrent {
    final current = _currentPosition;
    if (current == null) return null;
    return Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      _target.latitude,
      _target.longitude,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apiKey = ref.read(envConfigProvider).googleMapsApiKey;

    if (apiKey.isEmpty) {
      return _MapNotConfiguredView(l10n: l10n);
    }

    final distance = _distanceFromCurrent;
    final showDistanceWarning = distance != null && distance > _farPinThresholdMeters;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _target, zoom: 16),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) => _target = position.target,
            onCameraIdle: () => _reverseGeocode(_target),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          IgnorePointer(
            child: Align(
              alignment: Alignment.center,
              child: FractionalTranslation(
                translation: const Offset(0, -0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                      ),
                      child: Text(l10n.deliveredHereLabel, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    Icon(Icons.location_on, size: 44, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: _search,
                        decoration: InputDecoration(
                          hintText: l10n.searchAddressHint,
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.md,
            bottom: 180,
            child: FloatingActionButton.small(
              heroTag: 'currentLocation',
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _resolvingAddress
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  _streetArea ?? '',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                        ),
                      ],
                    ),
                    if (showDistanceWarning) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.pinDistanceWarning(formatDistance(context, distance)),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: _streetArea == null
                          ? null
                          : () async {
                              final address = await context.push<Address>(
                                RoutePaths.addressDetails,
                                extra: PickedLocation(
                                  latitude: _target.latitude,
                                  longitude: _target.longitude,
                                  streetArea: _streetArea!,
                                  existing: widget.initial,
                                ),
                              );
                              if (address != null && context.mounted) {
                                context.pop(address);
                              }
                            },
                      child: Text(l10n.addAddressDetailsAction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapNotConfiguredView extends StatelessWidget {
  const _MapNotConfiguredView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addressDetailsTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 56, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.mapNotConfiguredTitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.mapNotConfiguredMessage,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
