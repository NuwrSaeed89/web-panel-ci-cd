import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/clients/client_card_widget.dart';

class ClientsGridWidget extends StatelessWidget {
  final ClientsController controller;
  final bool isDark;

  const ClientsGridWidget({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Filter Section (only for wide screens)
            if (isWideScreen) ...[
              _buildSearchSection(),
              const SizedBox(height: 24),
            ],

            // Results Count
            if (controller.filteredClients.isNotEmpty) _buildResultsCount(),

            // Clients Grid
            _buildClientsGrid(),
          ],
        );
      },
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

  Widget _buildResultsCount() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        'تم العثور على ${controller.filteredClients.length} زبون',
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildClientsGrid() {
    if (controller.filteredClients.isEmpty) {
      return _buildNoResultsWidget();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          double childAspectRatio;

          if (constraints.maxWidth > 1200) {
            crossAxisCount = 3;
            childAspectRatio = 1;
          } else if (constraints.maxWidth > 900) {
            crossAxisCount = 3;
            childAspectRatio = 0.6;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 2;
            childAspectRatio = 0.7;
          } else {
            crossAxisCount = 1;
            childAspectRatio = 1.2;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.filteredClients.length,
            itemBuilder: (context, index) {
              final client = controller.filteredClients[index];
              return ClientCardWidget(
                client: client,
                isDark: isDark,
                controller: controller,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TTextStyles.heading3.copyWith(
              color: isDark ? Colors.white : Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تغيير كلمات البحث',
            style: TTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
