import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/mobile_preview_controller.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

class MobilePreviewWidget extends StatefulWidget {
  final Widget child;
  final int currentTabIndex;

  const MobilePreviewWidget({
    super.key,
    required this.child,
    required this.currentTabIndex,
  });

  @override
  State<MobilePreviewWidget> createState() => _MobilePreviewWidgetState();
}

class _MobilePreviewWidgetState extends State<MobilePreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final mobilePreviewController = Get.find<MobilePreviewController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      if (!mobilePreviewController.isVisible.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        left: mobilePreviewController.position.value.dx,
        top: mobilePreviewController.position.value.dy,
        child: GestureDetector(
          onPanStart: (details) {
            mobilePreviewController.startDragging();
          },
          onPanUpdate: (details) {
            if (mobilePreviewController.isDragging) {
              final newPosition = Offset(
                mobilePreviewController.position.value.dx + details.delta.dx,
                mobilePreviewController.position.value.dy + details.delta.dy,
              );
              mobilePreviewController.updatePosition(newPosition);
            }
          },
          onPanEnd: (details) {
            mobilePreviewController.stopDragging();
          },
          child: Container(
            width: mobilePreviewController.size.value.width,
            height: mobilePreviewController.size.value.height,
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? const Color(0xFF1a1a2e)
                  : const Color(0xFFf5f5f5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeController.isDarkMode
                    ? Colors.white24
                    : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header مع أزرار التحكم
                //  _buildHeader(mobilePreviewController, themeController),

                // محتوى الشاشة
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? const Color(0xFF16213e)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeController.isDarkMode
                            ? Colors.white12
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
