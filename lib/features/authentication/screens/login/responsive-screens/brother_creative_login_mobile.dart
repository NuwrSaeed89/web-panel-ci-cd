import 'package:brother_admin_panel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/widgets/login_header.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrotherCreativeLoginScreenMobile extends StatelessWidget {
  const BrotherCreativeLoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [TLoginHeader(), TLoginForm()],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
