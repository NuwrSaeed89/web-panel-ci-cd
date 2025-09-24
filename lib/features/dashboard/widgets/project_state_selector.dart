import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectStateSelector extends StatelessWidget {
  final String currentState;
  final Function(String) onStateChanged;
  final bool isEditable;

  const ProjectStateSelector({
    super.key,
    required this.currentState,
    required this.onStateChanged,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    final states = [
      {
        'key': 'pending',
        'icon': Icons.schedule,
        'color': TColors.primary,
        'label': 'pending'
      },
      {
        'key': 'inProgress',
        'icon': Icons.engineering,
        'color': TColors.primary,
        'label': 'inProgress'
      },
      {
        'key': 'completed',
        'icon': Icons.check_circle,
        'color': TColors.primary,
        'label': 'completed'
      },
      {
        'key': 'cancelled',
        'icon': Icons.cancel,
        'color': TColors.primary,
        'label': 'cancelled'
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projectState'.tr,
            style: const TextStyle(
              fontSize: FontConstants.lg,
              fontWeight: FontConstants.bold,
              fontFamily: FontConstants.primaryFont,
            ),
          ),
          const SizedBox(height: 16),

          // States Grid - Responsive
          LayoutBuilder(
            builder: (context, constraints) {
              // Check if screen is mobile (width < 600)
              final bool isMobile = constraints.maxWidth < 600;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      isMobile ? 2 : 4, // 2 columns on mobile, 4 on desktop
                  crossAxisSpacing: isMobile ? 8 : 12,
                  mainAxisSpacing: isMobile ? 8 : 12,
                  childAspectRatio: isMobile
                      ? 3.0
                      : 2.5, // Taller on mobile for better text visibility
                ),
                itemCount: states.length,
                itemBuilder: (context, index) {
                  final state = states[index];
                  final isActive = state['key'] == currentState;

                  return GestureDetector(
                    onTap: isEditable
                        ? () => onStateChanged(state['key'] as String)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive
                            ? (state['color'] as Color)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? state['color'] as Color
                              : Colors.grey.shade300,
                          width: isActive ? 2 : 1,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: (state['color'] as Color)
                                      .withValues(alpha: .3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isMobile
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state['icon'] as IconData,
                                  color: isActive
                                      ? Colors.white
                                      : (state['color'] as Color),
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state['label'].toString().tr,
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : (state['color'] as Color),
                                    fontWeight: isActive
                                        ? FontConstants.bold
                                        : FontConstants.regular,
                                    fontFamily: FontConstants.primaryFont,
                                    fontSize: FontConstants.xs,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state['icon'] as IconData,
                                  color: isActive
                                      ? Colors.white
                                      : (state['color'] as Color),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state['label'].toString().tr,
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : (state['color'] as Color),
                                      fontWeight: isActive
                                          ? FontConstants.bold
                                          : FontConstants.regular,
                                      fontFamily: FontConstants.primaryFont,
                                      fontSize: FontConstants.sm,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 16),

          // Current State Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStateColor(currentState).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStateColor(currentState).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStateIcon(currentState),
                  color: _getStateColor(currentState),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${'projectState'.tr}: ${currentState.tr}',
                    style: TextStyle(
                      color: _getStateColor(currentState),
                      fontWeight: FontConstants.semiBold,
                      fontFamily: FontConstants.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return TColors.primary;
      case 'inprogress':
        return TColors.primary;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStateIcon(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'inprogress':
        return Icons.engineering;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
