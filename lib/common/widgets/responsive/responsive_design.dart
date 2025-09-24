// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TResponsiveWidget extends StatelessWidget {
  const TResponsiveWidget({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth >= TSizes.desctopScreenSize) {
        return desktop;
      } else if (constraints.maxWidth < TSizes.desctopScreenSize &&
          constraints.maxWidth >= TSizes.tabletScreenSize) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
