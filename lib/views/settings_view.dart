// lib/views/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_settings_controller.dart';

import '../styles/app_text.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  SettingsPage({super.key}) {
    controller.loadFromStorage();
    controller.fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: Obx(() {
        if (controller.isLoading.value && controller.settings.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final s = controller.settings.value;
        if (s == null) {
          return const Center(child: AppText('No settings available', color: Colors.grey));
        }

        // Example: show force-update dialog if needed
        if (s.appAndroidForceUpdate == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
         //   _showForceUpdateDialog(context, s);
          });
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ListTile(
              title: const Text('Android App Version'),
              subtitle: Text(s.appAndroidVersion ?? '—'),
            ),
            ListTile(
              title: const Text('iOS App Version'),
              subtitle: Text(s.appIosVersion ?? '—'),
            ),
            // SwitchListTile(
            //   title: const Text('Maintenance Mode'),
            //   value: s.appMaintenanceMode,
            //   onChanged: (_) {},
            // ),
            ListTile(
              title: const Text('Support Email'),
              subtitle: Text(s.supportEmailId ?? '-'),
            ),
            ListTile(
              title: const Text('Contact Number'),
              subtitle: Text(s.conatctNumber ?? '-'),
            ),
            ListTile(
              title: const Text('WhatsApp'),
              subtitle: Text(s.whatsappNumber ?? '-'),
            ),
            ListTile(
              title: const Text('Terms & Conditions'),
              subtitle: Text(s.termsAndConditionUrl ?? '-'),
              //onTap: () => _launchUrl(s.termsAndConditionUrl),
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              subtitle: Text(s.privacyUrl ?? '-'),
             // onTap: () => _launchUrl(s.privacyUrl),
            ),
          ],
        );
      }),
    );
  }



}
