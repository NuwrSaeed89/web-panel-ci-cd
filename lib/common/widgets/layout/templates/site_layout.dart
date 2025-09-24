import 'package:brother_admin_panel/common/widgets/responsive/responsive_design.dart';
import 'package:brother_admin_panel/common/widgets/responsive/screen/desktop_layout.dart';
import 'package:brother_admin_panel/common/widgets/responsive/screen/mobile_layout.dart';
import 'package:brother_admin_panel/common/widgets/responsive/screen/tablet_layout.dart';
import 'package:flutter/material.dart';

class TSiteTemplate extends StatelessWidget {
  const TSiteTemplate(
      {super.key,
      this.desktop,
      this.mobile,
      this.tablet,
      this.useLayout = false});
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final bool useLayout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TResponsiveWidget(
        desktop:
            useLayout ? DesktopLayout(body: desktop) : desktop ?? Container(),
        tablet: useLayout
            ? TabletLayout(
                body: tablet ?? desktop,
              )
            : tablet ?? desktop ?? Container(),
        mobile: useLayout
            ? MobileLayout(body: mobile ?? desktop)
            : mobile ?? desktop ?? Container(),
      ),
    );
  }
}
