import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';
import 'package:brother_admin_panel/data/models/clients_model.dart';

class ClientCardWidget extends StatelessWidget {
  final ClientModel client;
  final bool isDark;
  final ClientsController controller;

  const ClientCardWidget({
    super.key,
    required this.client,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Main content
            _buildMainContent(),
            // Edit icons overlay
            _buildEditIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return InkWell(
      onTap: () => controller.showEditForm(client),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Image
            _buildClientImage(),
            const SizedBox(height: 8),

            // Client Name
            _buildClientName(),
            const SizedBox(height: 4),

            // Client Description
            _buildClientDescription(),

            const Spacer(),

            // Feature Badge
            _buildFeatureBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientImage() {
    if (client.thumbnail.isNotEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: NetworkImage(client.thumbnail),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Loading indicator overlay
            Obx(() => controller.isUploadingImage &&
                    controller.selectedClient?.id == client.id
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      );
    } else {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey.shade300,
        ),
        child: const Icon(
          Icons.person,
          size: 30,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget _buildClientName() {
    return Text(
      client.arabicName?.isNotEmpty == true
          ? client.arabicName!
          : client.name ?? 'زبون',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildClientDescription() {
    if (client.arabicText?.isNotEmpty == true ||
        client.text?.isNotEmpty == true) {
      return Text(
        client.arabicText?.isNotEmpty == true
            ? client.arabicText!
            : client.text ?? '',
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFeatureBadge() {
    if (client.isFeature) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'مميز',
          style: TTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 9,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEditIcons() {
    return Positioned(
      top: 4,
      right: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit image icon
          Obx(() => _buildEditIcon(
                icon: controller.isUploadingImage &&
                        controller.selectedClient?.id == client.id
                    ? Icons.hourglass_empty
                    : Icons.photo_camera,
                color: controller.isUploadingImage &&
                        controller.selectedClient?.id == client.id
                    ? Colors.orange
                    : Colors.blue,
                tooltip: controller.isUploadingImage &&
                        controller.selectedClient?.id == client.id
                    ? 'جاري رفع الصورة...'
                    : 'تعديل الصورة',
                onPressed: controller.isUploadingImage &&
                        controller.selectedClient?.id == client.id
                    ? () {} // لا تفعل شيئاً أثناء الرفع
                    : _showEditImageDialog,
              )),
          const SizedBox(width: 4),
          // Edit info icon
          _buildEditIcon(
            icon: Icons.edit,
            color: Colors.green,
            tooltip: 'تعديل المعلومات',
            onPressed: () => controller.showEditForm(client),
          ),
          const SizedBox(width: 4),
          // Delete icon
          Obx(() => _buildEditIcon(
                icon:
                    controller.isLoading ? Icons.hourglass_empty : Icons.delete,
                color: controller.isLoading ? Colors.grey : Colors.red,
                tooltip:
                    controller.isLoading ? 'جاري المعالجة...' : 'حذف الزبون',
                onPressed: controller.isLoading ? () {} : _showDeleteDialog,
              )),
        ],
      ),
    );
  }

  Widget _buildEditIcon({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 16,
          color: color,
        ),
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        tooltip: tooltip,
      ),
    );
  }

  void _showEditImageDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'تعديل صورة الزبون',
          style: TTextStyles.heading4.copyWith(
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Current image preview
            _buildImagePreview(),
            const SizedBox(height: 16),
            Text(
              'اختر صورة جديدة للزبون',
              style: TTextStyles.bodyMedium.copyWith(
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            const SizedBox(height: 16),
            // Loading indicator
            Obx(() => controller.isUploadingImage
                ? Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text(
                        'جاري رفع الصورة...',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: controller.isUploadingImage ? null : Get.back,
            child: const Text(
              'إلغاء',
              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
          ElevatedButton.icon(
            onPressed: controller.isUploadingImage
                ? null
                : () {
                    Get.back();
                    controller.pickAndUploadImage(client.id!);
                  },
            icon: const Icon(Icons.photo_camera),
            label: const Text(
              'اختيار صورة',
              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (client.thumbnail.isNotEmpty) {
      return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(client.thumbnail),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade300,
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.grey,
        ),
      );
    }
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'هل أنت متأكد من حذف هذا الزبون؟',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'اسم الزبون: ${client.arabicName?.isNotEmpty == true ? client.arabicName! : client.name ?? 'غير محدد'}',
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'تحذير: لا يمكن التراجع عن هذا الإجراء!',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // إغلاق النافذة أولاً
              await controller.deleteClient(client.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'حذف',
              style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }
}
