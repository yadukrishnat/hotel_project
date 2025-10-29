// lib/views/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/app_settings_controller.dart';
import '../module/setting_module.dart';


class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  SettingsPage({super.key}) {
    controller.loadFromStorage();
    controller.fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.settings.value == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 2,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading settings...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final s = controller.settings.value;
        if (s == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No settings available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Example: show force-update dialog if needed
        if (s.appAndroidForceUpdate == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // _showForceUpdateDialog(context, s);
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Info Card
              buildSectionCard(
                title: 'App Information',
                icon: Icons.info_outlined,
                color: Colors.blue,
                children: [
                  buildInfoItem(
                    icon: Icons.android,
                    title: 'Android Version',
                    value: s.appAndroidVersion ?? '—',
                    color: Colors.green,
                  ),

                  if (s.appMaintenanceMode == true)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 16,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Maintenance Mode Active',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Support Card
              buildSectionCard(
                title: 'Support & Contact',
                icon: Icons.support_agent_outlined,
                color: Colors.green,
                children: [
                  buildContactItem(
                    icon: Icons.email_outlined,
                    title: 'Support Email',
                    value: s.supportEmailId ?? '-',
                  ),
                  buildContactItem(
                    icon: Icons.phone_outlined,
                    title: 'Contact Number',
                    value: s.conatctNumber ?? '-',
                  ),
                  buildContactItem(
                    icon: Icons.chat_outlined,
                    title: 'WhatsApp',
                    value: s.whatsappNumber ?? '-',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Legal Card
              buildSectionCard(
                title: 'Legal',
                icon: Icons.gavel_outlined,
                color: Colors.purple,
                children: [
                  buildLegalItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    value: 'View our terms of service',
                  ),
                  buildLegalItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    value: 'Learn about data usage',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Actions Card

              const SizedBox(height: 30),

              // App Version Footer
              Center(
                child: Text(
                  'Hotel Finder v${s.appAndroidVersion ?? '1.0.0'}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // 🎴 Section Card





}
