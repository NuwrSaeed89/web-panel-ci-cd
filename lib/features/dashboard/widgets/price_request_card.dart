import 'package:brother_admin_panel/data/models/ask_request_model.dart';
import 'package:brother_admin_panel/data/repositories/project/project_repository.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/helpers/theme_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceRequestCard extends StatelessWidget {
  final AskRequestModel request;
  final VoidCallback onTap;

  const PriceRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
        future:
            ProjectRepository.instance.fetchUserDetailsById(request.uId ?? ''),
        builder: (context, snapshot) {
          final clientName = snapshot.data?['fullName'] ?? 'مستخدم غير معروف';

          return Card(
            elevation: 2,
            margin: const EdgeInsets.all(4),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ThemeHelper.getCardBackgroundColor(
                      Get.find<ThemeController>().isDarkMode),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان الطلب
                    Row(
                      children: [
                        const Icon(
                          Icons.request_quote,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            request.title,
                            style: TTextStyles.heading4.copyWith(
                              // color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // اسم العميل
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          // color: TColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${'client'.tr}: $clientName',
                            style: TTextStyles.bodySmall.copyWith(
                              //  color: TColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // إيميل العميل
                    if (request.userEmail != null &&
                        request.userEmail!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: TColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              request.userEmail!,
                              style: TTextStyles.bodySmall.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 6),

                    // حالة الطلب
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.state ?? ''),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (request.state ?? 'pending').tr,
                        style: TTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // الكمية
                    if (request.quantity != null &&
                        request.quantity!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory,
                            color: TColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${'requestQuantity'.tr}: ${request.quantity}',
                              style: TTextStyles.bodySmall.copyWith(
                                //  color: Colors.purple.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),

                    // معلومات إضافية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // الشركة
                        if (request.company != null &&
                            request.company!.isNotEmpty)
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.business,
                                  //color: Colors.grey.shade600,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    request.company!,
                                    style: TTextStyles.bodySmall.copyWith(
                                      // color: Color(0xFF222222),
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // السعر المقترح
                        if (request.proposedPrice != null &&
                            request.proposedPrice! > 0)
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                //  color: TColors.primary,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${request.proposedPrice!.toStringAsFixed(0)} ر.س',
                                style: TTextStyles.bodySmall.copyWith(
                                  // color: TColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    // التاريخ
                    if (request.dateTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              // color: Colors.grey.shade600,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                request.formattedStartDate,
                                style: TTextStyles.bodySmall.copyWith(
                                  //color: Color(0xFF222222),
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'معلق':
        return TColors.primary;
      case 'accepted':
      case 'مقبول':
        return TColors.primary;
      case 'rejected':
      case 'مرفوض':
        return Colors.red;
      case 'approved':
      case 'موافق عليه':
        return TColors.primary;
      default:
        return Colors.grey;
    }
  }
}
