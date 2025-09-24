import 'package:brother_admin_panel/utils/constants/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectStageFlow extends StatelessWidget {
  final String currentStage;
  final Function(String) onStageChanged;
  final bool isEditable;

  const ProjectStageFlow({
    super.key,
    required this.currentStage,
    required this.onStageChanged,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      {'key': 'pending', 'icon': Icons.schedule, 'color': Colors.orange},
      {'key': 'planing', 'icon': Icons.assignment, 'color': Colors.blue},
      {'key': 'process', 'icon': Icons.engineering, 'color': Colors.purple},
      {'key': 'delevering', 'icon': Icons.check_circle, 'color': Colors.green},
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
            'currentStage'.tr,
            style: const TextStyle(
              fontSize: FontConstants.lg,
              fontWeight: FontConstants.bold,
              fontFamily: FontConstants.primaryFont,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isActive = stage['key'] == currentStage;
              final isCompleted =
                  _isStageCompleted(stage['key'] as String, currentStage);

              return Expanded(
                child: Row(
                  children: [
                    // Stage Circle
                    GestureDetector(
                      onTap: isEditable
                          ? () => onStageChanged(stage['key'] as String)
                          : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? stage['color'] as Color
                              : isCompleted
                                  ? (stage['color'] as Color)
                                      .withValues(alpha: 0.3)
                                  : Colors.grey.shade300,
                          border: Border.all(
                            color: isActive
                                ? stage['color'] as Color
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          stage['icon'] as IconData,
                          color: isActive
                              ? Colors.white
                              : isCompleted
                                  ? stage['color'] as Color
                                  : Colors.grey.shade600,
                          size: 24,
                        ),
                      ),
                    ),

                    // Stage Label
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          stage['key'].toString().tr,
                          style: TextStyle(
                            fontSize: FontConstants.xs,
                            fontWeight: isActive
                                ? FontConstants.bold
                                : FontConstants.regular,
                            color: isActive
                                ? stage['color'] as Color
                                : isCompleted
                                    ? (stage['color'] as Color)
                                        .withValues(alpha: 0.8)
                                    : Colors.grey.shade600,
                            fontFamily: FontConstants.primaryFont,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // Connector Line (except for last stage)
                    if (index < stages.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? (stages[index + 1]['color'] as Color)
                                  .withValues(alpha: 0.3)
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Current Stage Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStageColor(currentStage).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStageColor(currentStage).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStageIcon(currentStage),
                  color: _getStageColor(currentStage),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${'currentStage'.tr}: ${currentStage.tr}',
                    style: TextStyle(
                      color: _getStageColor(currentStage),
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

  bool _isStageCompleted(String stageKey, String currentStage) {
    final stageOrder = ['pending', 'planing', 'process', 'delevering'];
    final currentIndex = stageOrder.indexOf(currentStage);
    final stageIndex = stageOrder.indexOf(stageKey);
    return stageIndex <= currentIndex;
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'pending':
        return Colors.orange;
      case 'planing':
        return Colors.blue;
      case 'process':
        return Colors.purple;
      case 'delevering':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStageIcon(String stage) {
    switch (stage) {
      case 'pending':
        return Icons.schedule;
      case 'planing':
        return Icons.assignment;
      case 'process':
        return Icons.engineering;
      case 'delevering':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }
}
