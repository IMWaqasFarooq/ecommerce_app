import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/coupon.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

@freezed
abstract class CouponModel with _$CouponModel {
  const factory CouponModel({required String code, required double discountPercentage}) =
      _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) => _$CouponModelFromJson(json);
}

extension CouponModelMapper on CouponModel {
  Coupon toEntity() => Coupon(code: code, discountPercentage: discountPercentage);
}

extension CouponEntityMapper on Coupon {
  CouponModel toModel() => CouponModel(code: code, discountPercentage: discountPercentage);
}
