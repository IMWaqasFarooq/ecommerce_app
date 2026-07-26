import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/address.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String fullName,
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    required String phone,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}

extension AddressModelMapper on AddressModel {
  Address toEntity() => Address(
    fullName: fullName,
    line1: line1,
    line2: line2,
    city: city,
    state: state,
    postalCode: postalCode,
    country: country,
    phone: phone,
  );
}

extension AddressEntityMapper on Address {
  AddressModel toModel() => AddressModel(
    fullName: fullName,
    line1: line1,
    line2: line2,
    city: city,
    state: state,
    postalCode: postalCode,
    country: country,
    phone: phone,
  );
}
