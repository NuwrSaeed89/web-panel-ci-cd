import 'package:brother_admin_panel/routs/app_routes.dart';
import 'package:brother_admin_panel/utils/constants/text_strings.dart';
import 'package:brother_admin_panel/utils/themes/theme.dart';
import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:brother_admin_panel/localization/translations.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          title: TTexts.appName,
          debugShowCheckedModeBanner: false,
          themeMode: controller.themeMode, // استخدام الوضع من المتحكم
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,

          // إعدادات الترجمة
          translations: AppTranslations(),
          locale: LanguageController.to.locale,
          fallbackLocale: const Locale('en'),

          getPages: TAppRoute.pages,
          initialRoute: '/splash',
          unknownRoute: GetPage(
              name: '/page-not-found',
              page: () => const Scaffold(
                    body: Center(
                      child: Text(
                        'Page Not Found',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  )),
        );
      },
    );
  }
}
