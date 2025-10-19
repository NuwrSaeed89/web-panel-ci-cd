import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';

class ClientsHeaderWidget extends StatelessWidget {
  final ClientsController controller;
  final bool isDark;

  const ClientsHeaderWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth > 600;

          return isWideScreen ? _buildDesktopLayout() : _buildMobileLayout();
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'إدارة الزبائن',
            style: TTextStyles.heading2.copyWith(
              color: isDark ? Colors.white : Color(0xFF111111),
            ),
          ),
        ),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'إدارة الزبائن',
                style: TTextStyles.heading2.copyWith(
                  color: isDark ? Colors.white : Color(0xFF111111),
                ),
              ),
            ),
            _buildAddButton(),
          ],
        ),
        const SizedBox(height: 16),
        _buildSearchSection(),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: controller.showAddForm,
      icon: const Icon(Icons.add),
      label: const Text('إضافة زبون'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0055ff),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        TextField(
          onChanged: controller.searchClients,
          decoration: InputDecoration(
            hintText: 'البحث في الزبائن...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearSearch,
                    icon: const Icon(Icons.clear),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF111111),
          ),
        ),
      ],
    );
  }
}
