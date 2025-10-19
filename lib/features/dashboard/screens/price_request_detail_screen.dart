import 'package:brother_admin_panel/data/models/ask_request_model.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/price_request_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/font_constants.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceRequestDetailScreen extends StatelessWidget {
  final AskRequestModel request;
  final PriceRequestController _priceRequestController =
      Get.find<PriceRequestController>();

  PriceRequestDetailScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد الطلب في المتحكم
    _priceRequestController.selectRequest(request);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'requestDetails'.tr,
          style: TTextStyles.heading2.copyWith(
            color: Colors.white,
            fontFamily: FontConstants.primaryFont,
          ),
        ),
        // backgroundColor: Colors.orange.shade700,
        // foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _priceRequestController.resetForm,
            icon: const Icon(Icons.refresh),
            tooltip: 'reset'.tr,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          color: THelperFunctions.isDarkMode(context)
              ? const Color(0xFF0a0a0a)
              : const Color(0xFFfafafa),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildBasicInfoSection(),
              const SizedBox(height: 24),

              // Client Information
              _buildClientInfoSection(),
              const SizedBox(height: 24),

              // Editable Fields
              _buildEditableFieldsSection(),
              const SizedBox(height: 24),

              // Additional Information
              _buildAdditionalInfoSection(),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      color: THelperFunctions.isDarkMode(Get.context!)
          ? const Color(0xFF111111)
          : Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.request_quote,
                  color: TColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    request.title,
                    style: TTextStyles.heading1.copyWith(
                      color: Colors.orange.shade800,
                      fontFamily: FontConstants.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (request.description != null && request.description!.isNotEmpty)
              Text(
                request.description!,
                style: TTextStyles.bodyLarge.copyWith(
                  color: Color(0xFF222222),
                  fontFamily: FontConstants.primaryFont,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfoSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'clientInfo'.tr,
              style: TTextStyles.heading3.copyWith(
                color: Colors.green.shade700,
                fontFamily: FontConstants.primaryFont,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('clientName'.tr,
                request.userFullName ?? 'unknownUser'.tr, Icons.person),
            if (request.userEmail != null && request.userEmail!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child:
                    _buildInfoRow('email'.tr, request.userEmail!, Icons.email),
              ),
            if (request.phoneNumber != null && request.phoneNumber!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildInfoRow(
                    'phone'.tr, request.phoneNumber!, Icons.phone),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableFieldsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'editableFields'.tr,
              style: TTextStyles.heading3.copyWith(
                color: Colors.blue.shade700,
                fontFamily: FontConstants.primaryFont,
              ),
            ),
            const SizedBox(height: 16),

            // حالة القبول
            _buildEditableField(
              label: 'acceptanceStatus'.tr,
              controller: _priceRequestController.acceptanceStatusController,
              icon: Icons.check_circle,
              color: Colors.green,
              isDropdown: true,
              options: ['pending', 'accepted', 'rejected', 'approved'],
            ),
            const SizedBox(height: 16),

            // السعر المقترح
            _buildEditableField(
              label: 'priceProposal'.tr,
              controller: _priceRequestController.proposedPriceController,
              icon: Icons.attach_money,
              color: Colors.orange,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
    TextInputType? keyboardType,
    bool isDropdown = false,
    List<String>? options,
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
          child: isDropdown
              ? DropdownButtonFormField<String>(
                  value: controller.text.isNotEmpty ? controller.text : null,
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
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                  items: options?.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option.tr),
                        );
                      }).toList() ??
                      [],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.text = newValue;
                    }
                  },
                  style: const TextStyle(
                    fontFamily: FontConstants.primaryFont,
                  ),
                )
              : TextFormField(
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
                      fontFamily: 'IBM Plex Sans Arabic',
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
            if (request.quantity != null && request.quantity!.isNotEmpty)
              _buildInfoRow(
                  'requestQuantity'.tr, request.quantity!, Icons.inventory),
            if (request.quantity != null && request.quantity!.isNotEmpty)
              const SizedBox(height: 8),
            if (request.address != null && request.address!.isNotEmpty)
              _buildInfoRow(
                  'requestAddress'.tr, request.address!, Icons.location_on),
            if (request.address != null && request.address!.isNotEmpty)
              const SizedBox(height: 8),
            if (request.location != null && request.location!.isNotEmpty)
              _buildInfoRow(
                  'requestLocation'.tr, request.location!, Icons.place),
            if (request.location != null && request.location!.isNotEmpty)
              const SizedBox(height: 8),
            if (request.company != null && request.company!.isNotEmpty)
              _buildInfoRow(
                  'requestCompany'.tr, request.company!, Icons.business),
            if (request.company != null && request.company!.isNotEmpty)
              const SizedBox(height: 8),
            if (request.phoneNumber != null && request.phoneNumber!.isNotEmpty)
              _buildInfoRow(
                  'requestPhone'.tr, request.phoneNumber!, Icons.phone),
            if (request.phoneNumber != null && request.phoneNumber!.isNotEmpty)
              const SizedBox(height: 8),
            if (request.projectCategory != null &&
                request.projectCategory!.isNotEmpty)
              _buildInfoRow('requestCategory'.tr, request.projectCategory!,
                  Icons.category),
            if (request.dateTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildInfoRow('requestDate'.tr,
                    request.formattedStartDate, Icons.schedule),
              ),
            if (request.estimatedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildInfoRow(
                    'estimatedDate'.tr,
                    request.estimatedDate!.toString().split(' ')[0],
                    Icons.event),
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
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _priceRequestController.updatePriceRequest,
            icon: const Icon(Icons.save),
            label: Text(
              'updatePriceRequest'.tr,
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
            onPressed: _priceRequestController.resetForm,
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
  }
}
