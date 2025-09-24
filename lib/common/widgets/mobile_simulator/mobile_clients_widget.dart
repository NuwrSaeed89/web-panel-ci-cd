import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';

class MobileClientsWidget extends StatelessWidget {
  const MobileClientsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsController>(
      builder: (clientController) {
        final themeController = Get.find<ThemeController>();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'العملاء',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              
              // قائمة العملاء
              Obx(() {
                if (clientController.isLoading) {
                  return SizedBox(
                    height: 130,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode 
                                  ? const Color(0xFF2a2a3e) 
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                
                final featureClients = clientController.clients
                    .where((client) => client.isFeature)
                    .take(8)
                    .toList();
                
                if (featureClients.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد عملاء',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  );
                }
                
                return SizedBox(
                  height: 130,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: featureClients.length,
                    itemBuilder: (_, index) {
                      final client = featureClients[index];
                      return GestureDetector(
                        onTap: () {
                          // يمكن إضافة تفاعل هنا
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode 
                                  ? const Color(0xFF2a2a3e) 
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: themeController.isDarkMode
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRect(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(client.thumbnail),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
