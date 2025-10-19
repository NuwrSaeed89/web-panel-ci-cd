import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/order_controller.dart';
import 'package:brother_admin_panel/data/models/order_model.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';

class ShoppingOrdersScreen extends StatelessWidget {
  const ShoppingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Container(
          color: isDark ? const Color(0xFF0a0a0a) : const Color(0xFFf5f5f5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with Search and Filter
                _buildHeader(orderController, isDark),

                // Statistics Cards
                _buildStatisticsCards(orderController, isDark),

                // Orders List
                _buildOrdersList(orderController, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(OrderController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;

          return Column(
            children: [
              // Title and Refresh Button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ordersManagement'.tr,
                      style: TTextStyles.heading3.copyWith(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.refreshOrders(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'تحديث',
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // Search and Filter - Responsive Layout
              if (isMobile) ...[
                // Mobile: Stack vertically
                TextField(
                  onChanged: controller.searchOrders,
                  decoration: InputDecoration(
                    hintText: 'searchInOrders'.tr,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Obx(() => DropdownButtonFormField<OrderStatus?>(
                            value: controller.selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'filterByStatus'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor:
                                  isDark ? Colors.grey.shade800 : Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            items: [
                              DropdownMenuItem<OrderStatus?>(
                                value: null,
                                child: Text('allStatuses'.tr,
                                    style: const TextStyle(fontSize: 12)),
                              ),
                              ...OrderStatus.values
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                            controller.getStatusText(status),
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      )),
                            ],
                            onChanged: controller.filterByStatus,
                          )),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: controller.clearFilters,
                      icon: const Icon(Icons.clear, size: 18),
                      label: Text('clear'.tr,
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: const Size(0, 36),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Desktop: Horizontal layout
                Row(
                  children: [
                    // Search Field
                    Expanded(
                      flex: 2,
                      child: TextField(
                        onChanged: controller.searchOrders,
                        decoration: InputDecoration(
                          hintText: 'searchInOrders'.tr,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              isDark ? Colors.grey.shade800 : Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Status Filter
                    Expanded(
                      child: Obx(() => DropdownButtonFormField<OrderStatus?>(
                            value: controller.selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'filterByStatus'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor:
                                  isDark ? Colors.grey.shade800 : Colors.white,
                            ),
                            items: [
                              DropdownMenuItem<OrderStatus?>(
                                value: null,
                                child: Text('allStatuses'.tr),
                              ),
                              ...OrderStatus.values
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                            controller.getStatusText(status)),
                                      )),
                            ],
                            onChanged: controller.filterByStatus,
                          )),
                    ),

                    const SizedBox(width: 16),

                    // Clear Filters Button
                    ElevatedButton.icon(
                      onPressed: controller.clearFilters,
                      icon: const Icon(Icons.clear),
                      label: Text('clearFilters'.tr),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        // backgroundColor: Colors.grey.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatisticsCards(OrderController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;

          return Obx(() {
            final stats = [
              {
                'title': 'totalOrders'.tr,
                'value': controller.totalOrders.toString(),
                'icon': Icons.shopping_cart,
                'color': Colors.blue
              } as Map<String, dynamic>,
              {
                'title': 'processingOrders'.tr,
                'value': controller.processingOrders.toString(),
                'icon': Icons.hourglass_empty,
                'color': Colors.orange
              } as Map<String, dynamic>,
              {
                'title': 'pendingOrders'.tr,
                'value': controller.pendingOrders.toString(),
                'icon': Icons.pending,
                'color': Colors.blue
              } as Map<String, dynamic>,
              {
                'title': 'shippingOrders'.tr,
                'value': controller.shippingOrders.toString(),
                'icon': Icons.local_shipping,
                'color': Colors.purple
              } as Map<String, dynamic>,
              {
                'title': 'deliveredOrders'.tr,
                'value': controller.deliveredOrders.toString(),
                'icon': Icons.check_circle,
                'color': Colors.green
              } as Map<String, dynamic>,
            ];

            if (isMobile) {
              // Mobile: 2 columns
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              stats[0]['title']!,
                              stats[0]['value']!,
                              stats[0]['icon'] as IconData,
                              stats[0]['color'] as Color,
                              isDark)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildStatCard(
                              stats[1]['title']!,
                              stats[1]['value']!,
                              stats[1]['icon'] as IconData,
                              stats[1]['color'] as Color,
                              isDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              stats[2]['title']!,
                              stats[2]['value']!,
                              stats[2]['icon'] as IconData,
                              stats[2]['color'] as Color,
                              isDark)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildStatCard(
                              stats[3]['title']!,
                              stats[3]['value']!,
                              stats[3]['icon'] as IconData,
                              stats[3]['color'] as Color,
                              isDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              stats[4]['title']!,
                              stats[4]['value']!,
                              stats[4]['icon'] as IconData,
                              stats[4]['color'] as Color,
                              isDark)),
                      const SizedBox(width: 8),
                      const Expanded(
                          child: SizedBox()), // Empty space for alignment
                    ],
                  ),
                ],
              );
            } else {
              // Desktop: All in one row
              return Row(
                children: [
                  Expanded(
                      child: _buildStatCard(
                          stats[0]['title']!,
                          stats[0]['value']!,
                          stats[0]['icon'] as IconData,
                          stats[0]['color'] as Color,
                          isDark)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStatCard(
                          stats[1]['title']!,
                          stats[1]['value']!,
                          stats[1]['icon'] as IconData,
                          stats[1]['color'] as Color,
                          isDark)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStatCard(
                          stats[2]['title']!,
                          stats[2]['value']!,
                          stats[2]['icon'] as IconData,
                          stats[2]['color'] as Color,
                          isDark)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStatCard(
                          stats[3]['title']!,
                          stats[3]['value']!,
                          stats[3]['icon'] as IconData,
                          stats[3]['color'] as Color,
                          isDark)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildStatCard(
                          stats[4]['title']!,
                          stats[4]['value']!,
                          stats[4]['icon'] as IconData,
                          stats[4]['color'] as Color,
                          isDark)),
                ],
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111111) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isDark ? const Color(0xFF222222) : Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: isMobile ? 20 : 24),
              SizedBox(height: isMobile ? 6 : 8),
              Text(
                value,
                style: TTextStyles.heading4.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
              Text(
                title,
                style: TTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: isMobile ? 10 : 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(OrderController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: Obx(() {
        if (controller.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
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
                    onPressed: controller.refreshOrders,
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            ),
          );
        }

        final filteredOrders = controller.filteredOrders;

        if (filteredOrders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'noOrders'.tr,
                    style: TTextStyles.heading3.copyWith(
                      color: isDark ? Colors.white : Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'noOrdersFound'.tr,
                    style: TTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            ...filteredOrders.map((order) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildOrderCard(order, controller, isDark),
                )),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

  Widget _buildOrderCard(
      OrderModel order, OrderController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Card(
          margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
          color: isDark ? TColors.dark : TColors.light,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'orderNumber'.tr.replaceAll('{id}', order.id),
                            style: TTextStyles.heading4.copyWith(
                              color: isDark ? Colors.white : Color(0xFF111111),
                              fontSize: isMobile ? 14 : 16,
                            ),
                          ),
                          FutureBuilder<String>(
                            future: controller.getCustomerName(order.userId),
                            builder: (context, snapshot) {
                              final customerName =
                                  snapshot.data ?? order.userId;
                              return Text(
                                '${'customer'.tr}: $customerName',
                                style: TTextStyles.bodySmall.copyWith(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  fontSize: isMobile ? 10 : 12,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 12,
                          vertical: isMobile ? 4 : 6),
                      decoration: BoxDecoration(
                        color: controller
                            .getStatusColor(order.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: controller.getStatusColor(order.status)),
                      ),
                      child: Text(
                        controller.getStatusText(order.status),
                        style: TTextStyles.bodySmall.copyWith(
                          color: controller.getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 10 : 12,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 8 : 12),

                // Order Details - Responsive Layout
                if (isMobile) ...[
                  // Mobile: Stack vertically
                  _buildOrderDetail('date'.tr, order.formattedOrderDate,
                      Icons.calendar_today, isDark, isMobile),
                  const SizedBox(height: 8),
                  _buildOrderDetail(
                      'amount'.tr,
                      '${order.totalAmount.toStringAsFixed(2)} ر.س',
                      Icons.attach_money,
                      isDark,
                      isMobile),
                  const SizedBox(height: 8),
                  _buildOrderDetail('paymentMethod'.tr, order.paymentMethod,
                      Icons.payment, isDark, isMobile),
                ] else ...[
                  // Desktop: Horizontal layout
                  Row(
                    children: [
                      Expanded(
                        child: _buildOrderDetail(
                            'date'.tr,
                            order.formattedOrderDate,
                            Icons.calendar_today,
                            isDark,
                            isMobile),
                      ),
                      Expanded(
                        child: _buildOrderDetail(
                            'amount'.tr,
                            '${order.totalAmount.toStringAsFixed(2)} ر.س',
                            Icons.attach_money,
                            isDark,
                            isMobile),
                      ),
                      Expanded(
                        child: _buildOrderDetail(
                            'paymentMethod'.tr,
                            order.paymentMethod,
                            Icons.payment,
                            isDark,
                            isMobile),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: isMobile ? 8 : 12),

                // Items Count
                Text(
                  '${'productsCount'.tr}: ${order.items.length}',
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),

                SizedBox(height: isMobile ? 12 : 16),

                // Status Update Section - Responsive
                if (isMobile) ...[
                  // Mobile: Stack vertically
                  DropdownButtonFormField<OrderStatus>(
                    value: order.status,
                    decoration: InputDecoration(
                      labelText: 'updateStatus'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF222222)
                          : Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: OrderStatus.values
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(controller.getStatusText(status),
                                  style: const TextStyle(fontSize: 12)),
                            ))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null && newStatus != order.status) {
                        controller.updateOrderStatus(
                            order.id, order.userId, newStatus);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showOrderDetails(order, controller, isDark),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: Text('viewDetails'.tr,
                            style: const TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Desktop: Horizontal layout
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<OrderStatus>(
                          value: order.status,
                          decoration: InputDecoration(
                            labelText: 'updateStatus'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade50,
                          ),
                          items: OrderStatus.values
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child:
                                        Text(controller.getStatusText(status)),
                                  ))
                              .toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null &&
                                newStatus != order.status) {
                              controller.updateOrderStatus(
                                  order.id, order.userId, newStatus);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () =>
                            _showOrderDetails(order, controller, isDark),
                        icon: const Icon(Icons.visibility),
                        tooltip: 'viewDetails'.tr,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderDetail(
      String label, String value, IconData icon, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isMobile ? 14 : 16, color: Colors.grey),
            SizedBox(width: isMobile ? 3 : 4),
            Text(
              label,
              style: TTextStyles.bodySmall.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: isMobile ? 10 : 12,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 3 : 4),
        Text(
          value,
          style: TTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white : Color(0xFF111111),
            fontWeight: FontWeight.w500,
            fontSize: isMobile ? 12 : 14,
          ),
        ),
      ],
    );
  }

  void _showOrderDetails(
      OrderModel order, OrderController controller, bool isDark) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
        title: Text(
          'orderDetails'.tr.replaceAll('{id}', order.id),
          style: TTextStyles.heading4.copyWith(
            color: isDark ? Colors.white : Color(0xFF111111),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: controller.getCustomerName(order.userId),
                builder: (context, snapshot) {
                  final customerName = snapshot.data ?? order.userId;
                  return _buildDetailRow('customer'.tr, customerName, isDark);
                },
              ),
              _buildDetailRow(
                  'status'.tr, controller.getStatusText(order.status), isDark),
              _buildDetailRow('totalAmount'.tr,
                  '${order.totalAmount.toStringAsFixed(2)} ر.س', isDark),
              _buildDetailRow('orderDate'.tr, order.formattedOrderDate, isDark),
              _buildDetailRow('paymentMethod'.tr, order.paymentMethod, isDark),
              if (order.deliveryDate != null)
                _buildDetailRow(
                    'deliveryDate'.tr, order.formattedDeliveryDate, isDark),
              const SizedBox(height: 16),
              Text(
                '${'products'.tr}:',
                style: TTextStyles.bodyLarge.copyWith(
                  color: isDark ? Colors.white : Color(0xFF111111),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title.isNotEmpty
                                ? item.title
                                : item.product.title,
                            style: TTextStyles.bodyMedium.copyWith(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                        Text(
                          '${'quantity'.tr}: ${item.quantity}',
                          style: TTextStyles.bodySmall.copyWith(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
