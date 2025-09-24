import 'package:brother_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TListTilehummer extends StatelessWidget {
  const TListTilehummer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TShimmerEffect(
              width: 50,
              height: 50,
              raduis: BorderRadius.circular(50),
            ),
            const SizedBox(
              width: TSizes.spaceBtWItems,
            ),
            const Column(
              children: [
                TShimmerEffect(width: 100, height: 15),
                SizedBox(
                  width: TSizes.spaceBtWItems / 2,
                ),
                TShimmerEffect(width: 80, height: 12),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
