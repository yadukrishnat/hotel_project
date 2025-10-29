import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../module/google_auth_module.dart';

class GoogleAuthPage extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  GoogleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Decoration
            buildBackground(),

            // Main Content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Icon
                      buildAppIcon(),

                      const SizedBox(height: 32),

                      // Welcome Text
                      buildWelcomeText(),

                      const SizedBox(height: 48),

                      // Google Sign In Button
                      buildGoogleSignInButton(),

                      const SizedBox(height: 24),

                      // Divider
                      buildDivider(),

                      const SizedBox(height: 24),

                      // Feature Highlights
                      buildFeatureHighlights(),

                      const SizedBox(height: 40),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎨 Background Design

}