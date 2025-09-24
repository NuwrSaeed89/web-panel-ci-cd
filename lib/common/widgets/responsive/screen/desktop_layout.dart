import 'package:brother_admin_panel/common/widgets/layout/headers/header.dart';
import 'package:brother_admin_panel/common/widgets/layout/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: TSidebar()),
          Expanded(
            flex: 5,
            child: Column(
              children: [const THeader(), body ?? const SizedBox()],
            ),
          ),
        ],
      ),
    );
  }
}
