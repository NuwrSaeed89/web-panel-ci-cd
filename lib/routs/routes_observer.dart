import 'package:brother_admin_panel/common/widgets/layout/sidebars/sidebar_controller.dart';
import 'package:brother_admin_panel/routs/routs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteObserves extends GetObserver {
  @override
  void didPop(Route<dynamic>? route, Route? previousRoute) {
    final sidebarController = Get.put(SidebarController());
    if (previousRoute != null) {
      for (var routeName in TRoutes.sidebarMenuItem) {
        if (previousRoute.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
        }
      }
    }
  }
}
