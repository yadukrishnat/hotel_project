import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class GoogleAuthPage extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  GoogleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Hotel Finder',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Sign in to continue',
                    style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 40),

                // Login button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.loginWithGoogle,
                  icon: const Icon(Icons.login),
                  label: controller.isLoading.value
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text("Continue with Google",
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
