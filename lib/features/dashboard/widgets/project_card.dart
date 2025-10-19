import 'package:brother_admin_panel/data/models/project_model.dart';
import 'package:brother_admin_panel/data/repositories/project/project_repository.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/helpers/theme_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final ProjectRepository _projectRepository = ProjectRepository.instance;

  ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _projectRepository.fetchUserDetailsById(project.uId ?? ''),
      builder: (context, snapshot) {
        final clientName = snapshot.data?['fullName'] ?? 'مستخدم غير معروف';

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ThemeHelper.getCardBackgroundColor(
                    Get.find<ThemeController>().isDarkMode),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المشروع
                  Row(
                    children: [
                      Icon(
                        Icons.work,
                        color: Colors.blue.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          project.name,
                          style: TTextStyles.heading3.copyWith(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // اسم العميل
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${'client'.tr}: $clientName',
                          style: TTextStyles.bodyMedium.copyWith(
                            //   color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // حالة المشروع
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        // color: Colors.orange.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(project.state ?? ''),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            (project.state ?? 'pending').tr,
                            style: TTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // المرحلة الحالية
                  if (project.currentStage != null &&
                      project.currentStage!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.timeline,
                          // color: Colors.purple.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStageColor(project.currentStage!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              project.currentStage!.tr,
                              style: TTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // معلومات إضافية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // المدينة
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            project.city,
                            style: TTextStyles.bodySmall.copyWith(
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),

                      // التكلفة
                      if (project.cost != null && project.cost! > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: TColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${project.cost!.toStringAsFixed(0)} ${'currency'.tr}',
                              style: TTextStyles.bodySmall.copyWith(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'معلق':
      case 'pending':
        return TColors.primary;
      case 'قيد التنفيذ':
      case 'in progress':
        return TColors.primary;
      case 'مكتمل':
      case 'completed':
        return TColors.primary;
      case 'ملغي':
      case 'cancelled':
        return Colors.black26;
      default:
        return Colors.grey;
    }
  }

  Color _getStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'pending':
        return TColors.primary;
      case 'planing':
        return TColors.primary;
      case 'process':
        return TColors.primary;
      case 'delevering':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
