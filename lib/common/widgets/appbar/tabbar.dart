// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TTabbar extends StatelessWidget implements PreferredSizeWidget {
  const TTabbar({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<Widget> tabs;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? TColors.black : TColors.white,
      child: TabBar(
          isScrollable: true,
          indicatorColor: TColors.primary,
          unselectedLabelColor: TColors.darkGrey,
          labelColor: dark ? TColors.white : TColors.black,
          tabs: tabs),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0.1);
}
