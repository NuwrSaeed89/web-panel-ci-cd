import 'package:brother_admin_panel/common/widgets/layout/grid_layout.dart';
import 'package:brother_admin_panel/common/widgets/shimmers/shimmer.dart';

import 'package:flutter/material.dart';

class TGalleryPhotoShummer extends StatelessWidget {
  const TGalleryPhotoShummer({super.key, this.itemCount = 4});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return TGridLayout(
        maxAxisExtent: 190,
        itemCount: itemCount,
        itemBuilder: (_, __) => const SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TShimmerEffect(width: 180, height: 180),
                ],
              ),
            ));
  }
}
