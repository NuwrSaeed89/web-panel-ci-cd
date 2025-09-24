import 'package:brother_admin_panel/common/widgets/layout/grid_layout.dart';
import 'package:brother_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TVerticalProductShummer extends StatelessWidget {
  const TVerticalProductShummer({super.key, this.itemCount = 4});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return TGridLayout(
        itemCount: itemCount,
        itemBuilder: (_, __) => const SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TShimmerEffect(width: 180, height: 180),
                  SizedBox(
                    height: TSizes.spaceBtWItems,
                  ),

                  ///text
                  TShimmerEffect(width: 160, height: 15),
                  SizedBox(height: TSizes.spaceBtWItems / 2),
                  TShimmerEffect(width: 110, height: 15),
                ],
              ),
            ));
  }
}
