import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/address.dart';
import '../../domain/entities/address_type.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id,
    required AddressType type,
    required String streetArea,
    double? latitude,
    double? longitude,
    required String apartmentOrVilla,
    String? buildingOrCluster,
    String? directions,
    String? nickname,
    required String fullName,
    required String phone,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}

extension AddressModelMapper on AddressModel {
  Address toEntity() => Address(
    id: id,
    type: type,
    streetArea: streetArea,
    latitude: latitude,
    longitude: longitude,
    apartmentOrVilla: apartmentOrVilla,
    buildingOrCluster: buildingOrCluster,
    directions: directions,
    nickname: nickname,
    fullName: fullName,
    phone: phone,
  );
}

extension AddressEntityMapper on Address {
  AddressModel toModel() => AddressModel(
    id: id,
    type: type,
    streetArea: streetArea,
    latitude: latitude,
    longitude: longitude,
    apartmentOrVilla: apartmentOrVilla,
    buildingOrCluster: buildingOrCluster,
    directions: directions,
    nickname: nickname,
    fullName: fullName,
    phone: phone,
  );
}
