import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/coupon.dart';

class CouponInput extends StatefulWidget {
  const CouponInput({required this.appliedCoupon, required this.onApply, required this.onRemove, super.key});

  final Coupon? appliedCoupon;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  @override
  State<CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coupon = widget.appliedCoupon;

    if (coupon != null) {
      return Row(
        children: [
          Chip(
            avatar: const Icon(Icons.local_offer_outlined, size: 16),
            label: Text('${coupon.code} (-${coupon.discountPercentage.round()}%)'),
            onDeleted: widget.onRemove,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(hintText: 'Coupon code'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        FilledButton.tonal(
          onPressed: () {
            if (_controller.text.trim().isEmpty) return;
            widget.onApply(_controller.text.trim());
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
