import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brother_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Map to track expanded state of each policy field
  final Map<ValueKey, bool> _expandedFields = {};

  @override
  Widget build(BuildContext context) {
    final brotherController = Get.find<BrotherController>();

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Container(
          color: isDark ? const Color(0xFF0a0a0a) : const Color(0xFFfafafa),
          child: Column(
            children: [
              // Header
              _buildHeader(brotherController, isDark),

              // Content
              Expanded(
                child: _buildContent(brotherController, isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BrotherController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive design based on screen width
          final isWideScreen = constraints.maxWidth > 768;

          if (isWideScreen) {
            // Desktop layout - horizontal
            return Row(
              children: [
                Expanded(
                  child: Text(
                    'companySettings'.tr,
                    style: TTextStyles.heading2.copyWith(
                      color: isDark ? Colors.white : Color(0xFF111111),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => controller.refreshData(),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'refresh'.tr,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: controller.isSaving
                      ? null
                      : () => controller.saveBrotherData(),
                  icon: controller.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                      controller.isSaving ? 'saving'.tr : 'saveSettings'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055ff),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            );
          } else {
            // Mobile layout - vertical
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'companySettings'.tr,
                  style: TTextStyles.heading2.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => controller.refreshData(),
                      icon: const Icon(Icons.refresh),
                      tooltip: 'refresh'.tr,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.isSaving
                            ? null
                            : () => controller.saveBrotherData(),
                        icon: controller.isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(controller.isSaving
                            ? 'saving'.tr
                            : 'saveSettings'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0055ff),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(BrotherController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: isDark ? Color(0xFF222222) : Colors.grey.shade200,
        // ),
      ),
      child: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage,
                  style: TTextStyles.bodyLarge.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshData,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Information Section
                  _buildResponsiveSection(
                    'companyInfo'.tr,
                    Icons.business,
                    isWideScreen,
                    [
                      if (isWideScreen)
                        // Desktop: Two columns
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.nameController,
                                label: 'companyNameEnglish'.tr,
                                hint: 'enterCompanyNameEnglish'.tr,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.arabicNameController,
                                label: 'companyNameArabic'.tr,
                                hint: 'enterCompanyNameArabic'.tr,
                                isDark: isDark,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        )
                      else
                        // Mobile: Single column
                        Column(
                          children: [
                            _buildTextField(
                              controller: controller.nameController,
                              label: 'companyNameEnglish'.tr,
                              hint: 'enterCompanyNameEnglish'.tr,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.arabicNameController,
                              label: 'companyNameArabic'.tr,
                              hint: 'enterCompanyNameArabic'.tr,
                              isDark: isDark,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      if (isWideScreen)
                        // Desktop: Two columns
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.primaryColorController,
                                label: 'primaryColor'.tr,
                                hint: 'exampleColor'.tr,
                                isDark: isDark,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.phoneNumbersController,
                                label: 'phoneNumbers'.tr,
                                hint: 'enterPhoneNumbers'.tr,
                                isDark: isDark,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        )
                      else
                        // Mobile: Single column
                        Column(
                          children: [
                            _buildTextField(
                              controller: controller.primaryColorController,
                              label: 'primaryColor'.tr,
                              hint: 'exampleColor'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.phoneNumbersController,
                              label: 'phoneNumbers'.tr,
                              hint: 'enterPhoneNumbers'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                    ],
                    isDark,
                  ),

                  const SizedBox(height: 32),

                  // About Us Section
                  _buildResponsiveSection(
                    'aboutUs'.tr,
                    Icons.info,
                    isWideScreen,
                    [
                      if (isWideScreen)
                        // Desktop: Two columns
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.aboutUsController,
                                label: 'aboutUsEnglish'.tr,
                                hint: 'enterCompanyDescriptionEnglish'.tr,
                                isDark: isDark,
                                maxLines: 4,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.arabicAboutUsController,
                                label: 'aboutUsArabic'.tr,
                                hint: 'enterCompanyDescriptionArabic'.tr,
                                isDark: isDark,
                                maxLines: 4,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        )
                      else
                        // Mobile: Single column
                        Column(
                          children: [
                            _buildTextField(
                              controller: controller.aboutUsController,
                              label: 'aboutUsEnglish'.tr,
                              hint: 'enterCompanyDescriptionEnglish'.tr,
                              isDark: isDark,
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: controller.arabicAboutUsController,
                              label: 'aboutUsArabic'.tr,
                              hint: 'enterCompanyDescriptionArabic'.tr,
                              isDark: isDark,
                              maxLines: 4,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                    ],
                    isDark,
                  ),

                  const SizedBox(height: 32),

                  // Policies Section
                  _buildPoliciesSection(controller, isDark),

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (isWideScreen)
                    // Desktop: Horizontal layout
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.resetForm,
                            icon: const Icon(Icons.restore),
                            label: Text('reset'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.clearForm,
                            icon: const Icon(Icons.clear),
                            label: Text('clearAll'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // Mobile: Vertical layout
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.resetForm,
                            icon: const Icon(Icons.restore),
                            label: Text('reset'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.clearForm,
                            icon: const Icon(Icons.clear),
                            label: Text('clearAll'.tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildPoliciesSection(BrotherController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : const Color(0xFFf8f8f8),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.policy, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text(
                'policies'.tr,
                style: TTextStyles.heading4.copyWith(
                  color: isDark ? Colors.white : Color(0xFF111111),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Privacy Policy
          _buildExpandablePolicyField(
            controller: controller.privacyPolicyController,
            label: 'privacyPolicyEnglish'.tr,
            hint: 'enterPrivacyPolicyEnglish'.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildExpandablePolicyField(
            controller: controller.arabicPrivacyPolicyController,
            label: 'privacyPolicyArabic'.tr,
            hint: 'enterPrivacyPolicyArabic'.tr,
            isDark: isDark,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),

          // Return Policy
          _buildExpandablePolicyField(
            controller: controller.returnPolicyController,
            label: 'returnPolicyEnglish'.tr,
            hint: 'enterReturnPolicyEnglish'.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildExpandablePolicyField(
            controller: controller.arabicReturnPolicyController,
            label: 'returnPolicyArabic'.tr,
            hint: 'enterReturnPolicyArabic'.tr,
            isDark: isDark,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),

          // Cancellation Policy
          _buildExpandablePolicyField(
            controller: controller.cancellationPolicyController,
            label: 'cancellationPolicyEnglish'.tr,
            hint: 'enterCancellationPolicyEnglish'.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildExpandablePolicyField(
            controller: controller.arabicCancellationPolicyController,
            label: 'cancellationPolicyArabic'.tr,
            hint: 'enterCancellationPolicyArabic'.tr,
            isDark: isDark,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),

          // Terms and Conditions
          _buildExpandablePolicyField(
            controller: controller.termsConditionController,
            label: 'termsConditionsEnglish'.tr,
            hint: 'enterTermsConditionsEnglish'.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildExpandablePolicyField(
            controller: controller.arabicTermsConditionController,
            label: 'termsConditionsArabic'.tr,
            hint: 'enterTermsConditionsArabic'.tr,
            isDark: isDark,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandablePolicyField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextDirection? textDirection,
  }) {
    final fieldKey = ValueKey(label);
    final isExpanded = _expandedFields[fieldKey] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with expand/collapse button
        InkWell(
          onTap: () {
            setState(() {
              _expandedFields[fieldKey] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF222222) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(
              //   color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
              // ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TTextStyles.bodyLarge.copyWith(
                      color: isDark ? Colors.white : Color(0xFF111111),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: AlwaysStoppedAnimation(isExpanded),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: isExpanded ? 3.14159 : 0.0, // 180 degrees
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Expandable content
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0,
          child: isExpanded
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: _buildTextField(
                    controller: controller,
                    label: label,
                    hint: hint,
                    isDark: isDark,
                    maxLines: 15,
                    textDirection: textDirection,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildResponsiveSection(String title, IconData icon, bool isWideScreen,
      List<Widget> children, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : const Color(0xFFf8f8f8),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TTextStyles.heading4.copyWith(
                  color: isDark ? Colors.white : Color(0xFF111111),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextDirection? textDirection,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textDirection: textDirection,
      style: TextStyle(
        color: isDark ? Colors.white : Color(0xFF111111),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.black54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade600 : const Color(0xFFd0d0d0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade600 : const Color(0xFFd0d0d0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF222222) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
