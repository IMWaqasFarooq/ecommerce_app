import 'package:equatable/equatable.dart';

import 'address_type.dart';

class Address extends Equatable {
  const Address({
    required this.id,
    required this.type,
    required this.streetArea,
    this.latitude,
    this.longitude,
    required this.apartmentOrVilla,
    this.buildingOrCluster,
    this.directions,
    this.nickname,
    required this.fullName,
    required this.phone,
  });

  final String id;
  final AddressType type;
  final String streetArea;
  final double? latitude;
  final double? longitude;
  final String apartmentOrVilla;
  final String? buildingOrCluster;
  final String? directions;
  final String? nickname;
  final String fullName;
  final String phone;

  String get formatted {
    final parts = [
      streetArea,
      apartmentOrVilla,
      if (buildingOrCluster != null && buildingOrCluster!.isNotEmpty) buildingOrCluster!,
    ];
    return parts.join('\n');
  }

  @override
  List<Object?> get props => [
    id,
    type,
    streetArea,
    latitude,
    longitude,
    apartmentOrVilla,
    buildingOrCluster,
    directions,
    nickname,
    fullName,
    phone,
  ];
}
