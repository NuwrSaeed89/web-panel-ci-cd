import 'package:brother_admin_panel/features/permissions/widgets/permissions_header.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_list.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_stats.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionsMobile extends StatelessWidget {
  const PermissionsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const PermissionsHeader(),
              const SizedBox(height: TSizes.spaceBtWsections),

              // Stats
              const PermissionsStats(),
              const SizedBox(height: TSizes.spaceBtWsections),

              // Permissions List Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).shadowColor.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'permissionsList'.tr,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.sm),
                    const PermissionsList(),
                  ],
                ),
              ),

              // Add some bottom padding for the floating action button
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
