import 'package:flutter/material.dart';

import '../../../../core/formatting/locale_formatting.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.rating, this.size = 16, super.key});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: Colors.amber),
        SizedBox(width: size * 0.25),
        Text(
          formatDecimal(context, rating, decimalDigits: 1),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
