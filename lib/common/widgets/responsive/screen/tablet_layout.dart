import 'package:brother_admin_panel/common/widgets/layout/headers/header.dart';
import 'package:brother_admin_panel/common/widgets/layout/sidebars/sidebar.dart';
import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});
  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const TSidebar(),
      appBar: THeader(
        scaffoldKey: scaffoldKey,
      ),
      body: body ?? const SizedBox(),
    );
  }
}
