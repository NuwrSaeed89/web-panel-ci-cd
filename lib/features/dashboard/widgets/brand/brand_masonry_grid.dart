import 'package:flutter/material.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/brand/brand_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandMasonryGrid extends StatelessWidget {
  final BuildContext context;
  final bool isDark;
  final BrandController controller;
  final int crossAxisCount;
  final double spacing;

  const BrandMasonryGrid({
    super.key,
    required this.context,
    required this.isDark,
    required this.controller,
    required this.crossAxisCount,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final brands = controller.filteredBrands;
    if (brands.isEmpty) return const SizedBox.shrink();

    // Fallback to regular grid if there are too few items
    if (brands.length < crossAxisCount) {
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4, // 4 أعمدة للتابلت
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return BrandCard(
            context: context,
            isDark: isDark,
            brand: brand,
            controller: controller,
            isMobile: false,
          );
        },
      );
    }

    // Create columns for masonry layout
    final columns = List.generate(crossAxisCount, (index) => <Widget>[]);

    // Distribute brands across columns
    for (int i = 0; i < brands.length; i++) {
      final brand = brands[i];
      final columnIndex = i % crossAxisCount;
      columns[columnIndex].add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: BrandCard(
            context: context,
            isDark: isDark,
            brand: brand,
            controller: controller,
            isMobile: false,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0) return const SizedBox.shrink();

        final columnWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columns.asMap().entries.map((entry) {
            final index = entry.key;
            final column = entry.value;
            return SizedBox(
              width: columnWidth,
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < crossAxisCount - 1 ? spacing / 2 : 0,
                  left: index > 0 ? spacing / 2 : 0,
                ),
                child: Column(
                  children: column,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
