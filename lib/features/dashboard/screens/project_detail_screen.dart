import 'package:brother_admin_panel/data/models/project_model.dart';
import 'package:brother_admin_panel/data/repositories/project/project_repository.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/project_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/project_stage_flow.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/project_state_selector.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/font_constants.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;
  final ProjectController _projectController = Get.find<ProjectController>();
  final ProjectRepository _projectRepository = ProjectRepository.instance;

  ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد المشروع في المتحكم
    _projectController.selectProject(project);

    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 600;
                return Text(
                  'projectDetails'.tr,
                  style: TTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontFamily: FontConstants.primaryFont,
                    fontSize: isMobile ? 18 : 24,
                  ),
                );
              },
            ),

            actionsIconTheme: const IconThemeData(color: Colors.white),
            actions: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isMobile = constraints.maxWidth < 600;
                  return IconButton(
                    onPressed: () => controller.resetForm(),
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: isMobile ? 20 : 24,
                    ),
                    tooltip: 'reset'.tr,
                    padding: EdgeInsets.all(isMobile ? 8 : 12),
                  );
                },
              ),
            ],
            toolbarHeight: 56, // Fixed height for mobile
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;
              return SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildBasicInfoSection(),
                    SizedBox(height: isMobile ? 16 : 24),

                    // Client Information
                    _buildClientInfoSection(),
                    SizedBox(height: isMobile ? 16 : 24),

                    // Editable Fields
                    _buildEditableFieldsSection(),
                    SizedBox(height: isMobile ? 16 : 24),

                    // Additional Information
                    _buildAdditionalInfoSection(),
                    SizedBox(height: isMobile ? 24 : 32),

                    // Action Buttons
                    _buildActionButtons(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBasicInfoSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.work,
                      color: Colors.blue.shade700,
                      size: isMobile ? 24 : 28,
                    ),
                    SizedBox(width: isMobile ? 8 : 12),
                    Expanded(
                      child: Text(
                        project.name,
                        style: TTextStyles.heading2.copyWith(
                          color: Colors.blue.shade800,
                          fontFamily: FontConstants.primaryFont,
                          fontSize: isMobile ? 18 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 16),
                Text(
                  project.description,
                  style: TTextStyles.bodyLarge.copyWith(
                    color: Color(0xFF222222),
                    fontFamily: FontConstants.primaryFont,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientInfoSection() {
    return FutureBuilder<Map<String, String>>(
      future: _projectRepository.fetchUserDetailsById(project.uId ?? ''),
      builder: (context, snapshot) {
        final clientName = snapshot.data?['fullName'] ?? 'مستخدم غير معروف';

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            return Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'clientInfo'.tr,
                      style: TTextStyles.heading3.copyWith(
                        color: TColors.primary,
                        fontFamily: FontConstants.primaryFont,
                        fontSize: isMobile ? 16 : 20,
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: TColors.primary,
                          size: isMobile ? 20 : 24,
                        ),
                        SizedBox(width: isMobile ? 8 : 12),
                        Expanded(
                          child: Text(
                            clientName,
                            style: TTextStyles.bodyLarge.copyWith(
                              color: TColors.primary,
                              fontWeight: FontConstants.semiBold,
                              fontFamily: FontConstants.primaryFont,
                              fontSize: isMobile ? 14 : 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableFieldsSection() {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            return Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'editableFields'.tr,
                      style: TTextStyles.heading3.copyWith(
                        color: TColors.primary,
                        fontFamily: FontConstants.primaryFont,
                        fontSize: isMobile ? 16 : 20,
                      ),
                    ),
                    SizedBox(height: isMobile ? 12 : 16),

                    // المرحلة الحالية - Task Flow
                    ProjectStageFlow(
                      currentStage:
                          controller.currentStageController.text.isNotEmpty
                              ? controller.currentStageController.text
                              : project.currentStage ?? 'pending',
                      onStageChanged: (String newStage) {
                        controller.currentStageController.text = newStage;
                        controller.update(); // تحديث الواجهة فوراً
                      },
                      isEditable: true,
                    ),
                    const SizedBox(height: 16),

                    // التكلفة
                    _buildEditableField(
                      label: 'cost'.tr,
                      controller: controller.costController,
                      icon: Icons.attach_money,
                      color: TColors.primary,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // تاريخ الانتهاء
                    _buildDateField(),
                    const SizedBox(height: 16),

                    // حالة المشروع - State Selector
                    ProjectStateSelector(
                      currentState: controller.stateController.text.isNotEmpty
                          ? controller.stateController.text
                          : project.state ?? 'pending',
                      onStateChanged: (String newState) {
                        controller.stateController.text = newState;
                        controller.update(); // تحديث الواجهة فوراً
                      },
                      isEditable: true,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
    TextInputType? keyboardType,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color, width: 2),
              ),
              labelStyle: TextStyle(
                color: color,
                fontFamily: FontConstants.primaryFont,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.edit,
          color: color,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Row(
          children: [
            Icon(
              Icons.event,
              color: Colors.orange.shade600,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller.deadLineDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'deadline'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.orange.shade600, width: 2),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.orange.shade600,
                    fontFamily: FontConstants.primaryFont,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        controller.selectDeadlineDate(Get.context!),
                    icon: const Icon(Icons.calendar_today),
                    color: Colors.orange.shade600,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.edit,
              color: Colors.orange.shade600,
              size: 20,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'additionalInfo'.tr,
              style: TTextStyles.heading3.copyWith(
                color: Color(0xFF222222),
                fontFamily: FontConstants.primaryFont,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('quantity'.tr, project.quantity, Icons.inventory),
            const SizedBox(height: 8),
            _buildInfoRow('city'.tr, project.city, Icons.location_city),
            const SizedBox(height: 8),
            _buildInfoRow('country'.tr, project.country, Icons.flag),
            if (project.currentPaied != null && project.currentPaied! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildInfoRow(
                    'paidAmount'.tr,
                    '${project.currentPaied!.toStringAsFixed(0)} ر.س',
                    Icons.payment),
              ),
            if (project.dateTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildInfoRow('creationDate'.tr,
                    project.formattedStartDate, Icons.schedule),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey.shade600,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TTextStyles.bodyMedium.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontConstants.medium,
            fontFamily: FontConstants.primaryFont,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TTextStyles.bodyMedium.copyWith(
              color: Colors.grey.shade800,
              fontFamily: FontConstants.primaryFont,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.updateProject(),
                icon: const Icon(Icons.save),
                label: Text(
                  'saveChanges'.tr,
                  style: const TextStyle(
                    fontFamily: FontConstants.primaryFont,
                    fontSize: FontConstants.base,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.resetForm(),
                icon: const Icon(Icons.cancel),
                label: Text(
                  'cancel'.tr,
                  style: const TextStyle(
                    fontFamily: FontConstants.primaryFont,
                    fontSize: FontConstants.base,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.red.shade600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
