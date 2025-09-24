import 'dart:convert';

import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class BrandCard extends StatelessWidget {
  final BuildContext context;
  final bool isDark;
  final BrandModel brand;
  final BrandController controller;
  final bool isMobile;

  const BrandCard({
    super.key,
    required this.context,
    required this.isDark,
    required this.brand,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: Print brand information
    if (kDebugMode) {
      print(
          'BrandCard - Brand ID: ${brand.id}, Name: "${brand.name}", Image: "${brand.image}"');
      print(
          'BrandCard - Product Count: ${brand.productCount}, Is Feature: ${brand.isFeature}');
      print('BrandCard - Building widget for brand: ${brand.name}');
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1a2e) : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: isMobile ? 6 : 10,
                  offset: Offset(0, isMobile ? 2 : 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: isMobile ? 4 : 8,
                  offset: Offset(0, isMobile ? 1 : 2),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand Image
          Container(
            height: isMobile ? 170 : 180,
            width: isMobile ? 170 : 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isMobile ? 12 : 16),
              ),
              color: isDark ? Colors.black12 : Colors.grey.shade100,
            ),
            child: brand.image.isNotEmpty
                ? _buildBrandImage(brand.image, isDark, isMobile)
                : _buildPlaceholderImage(isDark, isMobile),
          ),

          // Brand Info
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand Name - Enhanced Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? Colors.blue.withValues(alpha: 0.3)
                          : Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        brand.name.isNotEmpty ? brand.name : 'No Name',
                        style: (isMobile
                                ? TTextStyles.bodyMedium
                                : TTextStyles.heading4)
                            .copyWith(
                          color: isDark
                              ? Colors.blue.shade300
                              : Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (brand.name.isEmpty)
                        Text(
                          'ID: ${brand.id}',
                          style: TextStyle(
                            color: isDark
                                ? Colors.red.shade300
                                : Colors.red.shade700,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 12),

                // Product Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: isMobile ? 14 : 16,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                    SizedBox(width: isMobile ? 4 : 6),
                    Text(
                      '${brand.productCount ?? 0} منتج',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontSize: isMobile ? 11 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 12 : 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Edit Button
                    IconButton(
                      onPressed: () {
                        controller.showEditForm(brand);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: isDark ? TColors.primary : Colors.blue.shade700,
                        size: isMobile ? 18 : 20,
                      ),
                      tooltip: 'تعديل',
                      padding: EdgeInsets.all(isMobile ? 4 : 8),
                    ),
                    // Feature Toggle
                    IconButton(
                      onPressed: () {
                        controller.toggleFeatureStatus(brand.id);
                      },
                      icon: Icon(
                        brand.isFeature == true
                            ? Icons.star
                            : Icons.star_border,
                        color: brand.isFeature == true
                            ? Colors.amber
                            : (isDark ? Colors.white70 : Colors.grey.shade600),
                        size: isMobile ? 18 : 20,
                      ),
                      tooltip:
                          brand.isFeature == true ? 'إلغاء التمييز' : 'تمييز',
                      padding: EdgeInsets.all(isMobile ? 4 : 8),
                    ),
                    // Delete Button
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmation(
                            context, isDark, brand, controller);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: isDark ? Colors.red : Colors.red.shade700,
                        size: isMobile ? 18 : 20,
                      ),
                      tooltip: 'حذف',
                      padding: EdgeInsets.all(isMobile ? 4 : 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark,
      BrandModel brand, BrandController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1a1a2e) : Colors.white,
          title: Text(
            'تأكيد الحذف',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف الماركة "${brand.name}"؟',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteBrand(brand.id);
              },
              child: const Text(
                'حذف',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBrandImage(String imageUrl, bool isDark, bool isMobile) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      child: ClipOval(
        child: _getImageProvider(imageUrl, isDark, isMobile),
      ),
    );
  }

  Widget _buildPlaceholderImage(bool isDark, bool isMobile) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.grey.shade200,
      ),
      child: Icon(
        Icons.branding_watermark,
        color: isDark ? Colors.white54 : Colors.grey.shade600,
        size: isMobile ? 24 : 32,
      ),
    );
  }

  Widget _getImageProvider(String imageUrl, bool isDark, bool isMobile) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey.shade200,
            ),
            child: Icon(
              Icons.error,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              size: isMobile ? 24 : 32,
            ),
          );
        },
      );
    } else {
      try {
        return Image.memory(
          base64Decode(imageUrl),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.grey.shade200,
              ),
              child: Icon(
                Icons.error,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                size: isMobile ? 24 : 32,
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
          ),
          child: Icon(
            Icons.error,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            size: isMobile ? 24 : 32,
          ),
        );
      }
    }
  }
}
