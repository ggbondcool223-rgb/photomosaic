import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';
import '../../utils/logger.dart';

class SettingsLogic extends GetxController {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': Lang.settingsPrivacy,
      'icon': Icons.description_outlined,
      'action': 'privacy',
    },
    {
      'title': Lang.settingsPersonalInfoCollection,
      'icon': Icons.description_outlined,
      'action': 'collection',
    },
    {
      'title': Lang.settingsPersonalInfoSharing,
      'icon': Icons.description_outlined,
      'action': 'sharing',
    },
    {
      'title': Lang.settingsUserAgreement,
      'icon': Icons.description_outlined,
      'action': 'agreement',
    },
  ];

  void onItemTap(String action) {
    Logger.d('Settings item tapped: $action');
    switch (action) {
      case 'privacy':
        _showDocument(Lang.settingsPrivacy, _getPrivacyContent());
        break;
      case 'collection':
        _showDocument(Lang.settingsPersonalInfoCollection, _getCollectionContent());
        break;
      case 'sharing':
        _showDocument(Lang.settingsPersonalInfoSharing, _getSharingContent());
        break;
      case 'agreement':
        _showDocument(Lang.settingsUserAgreement, _getAgreementContent());
        break;
    }
  }

  void _showDocument(String title, String content) {
    Get.toNamed('/document', arguments: {'title': title, 'content': content});
  }

  String _getPrivacyContent() {
    return 'Privacy Policy\n\nWe take your privacy seriously. This application does not collect, store, or transmit any of your personal information. All data is stored locally on your device and is never uploaded to any server.\n\nOur Commitment:\n1. We do not collect your personal information\n2. We do not upload data to servers\n3. All features run completely locally\n4. We do not use any third-party analytics tools\n\nData Storage:\nAll your photos, collages, and works are stored exclusively on your device. We have no access to your data, and it never leaves your device.\n\nThird-Party Services:\nThis application does not integrate with any third-party services that would require sharing your personal information.\n\nUpdates:\nWe reserve the right to update this privacy policy. Any changes will be reflected in this document.\n\nContact:\nIf you have any questions about this privacy policy, please contact us through the app.';
  }

  String _getCollectionContent() {
    return 'Personal Information Collection and Usage List\n\nThis application does not collect any personal information.\n\nInformation We Do NOT Collect:\n- Personal identification information such as name, email, phone number\n- Device information or location data\n- Usage habits or browsing history\n- Any other personally identifiable information\n\nLocal Data Storage:\nAll data is stored locally on your device, giving you complete control over your information.\n\nNo Data Transmission:\nThis application does not transmit any data over the internet. All operations are performed entirely on your device.\n\nUser Control:\nYou have complete control over your data. You can delete any works, photos, or other data at any time through the application.\n\nNo Tracking:\nWe do not track your usage patterns, preferences, or any other behavioral data.\n\nData Retention:\nSince we do not collect any data, there is no data retention policy. All data remains on your device until you choose to delete it.';
  }

  String _getSharingContent() {
    return 'Personal Information Third-Party Sharing List\n\nThis application does not share your personal information with any third parties.\n\nReasons:\n1. We do not collect any personal information\n2. All features run completely locally\n3. We do not depend on any third-party services\n4. We do not make any network requests\n\nYour Data Belongs to You:\nYour data is completely yours. We cannot access it, and we will never share it with anyone.\n\nNo Third-Party Integrations:\nThis application does not integrate with social media platforms, cloud storage services, or any other third-party services that would require sharing your information.\n\nNo Advertising:\nThis application does not display advertisements, which means we do not share your information with advertisers.\n\nNo Analytics:\nWe do not use any analytics services that would track your usage or collect your information.\n\nComplete Privacy:\nYour privacy is our priority. We have designed this application to operate entirely offline and locally, ensuring your data never leaves your device.';
  }

  String _getAgreementContent() {
    return 'User Agreement\n\nWelcome to Photo Mosaic application.\n\nTerms of Use:\n1. This application is for personal use only\n2. Do not use this application for commercial purposes\n3. By using this application, you agree to this agreement\n\nLicense:\nThis application is provided for your personal, non-commercial use. You may not modify, distribute, or create derivative works based on this application.\n\nDisclaimer:\n1. This application is not responsible for any losses arising from the use of this application\n2. This application does not guarantee absolute stability of functions\n3. Users should back up important data on their own\n\nLimitation of Liability:\nTo the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of this application.\n\nIntellectual Property:\nAll content, features, and functionality of this application are owned by us and are protected by copyright and other intellectual property laws.\n\nModifications:\nWe reserve the right to modify this agreement at any time. Continued use of the application after modifications constitutes acceptance of the updated agreement.\n\nTermination:\nWe reserve the right to terminate or suspend your access to the application at any time, without prior notice, for any reason.\n\nGoverning Law:\nThis agreement shall be governed by and construed in accordance with applicable laws.';
  }

  @override
  void onInit() {
    super.onInit();
    Logger.d('SettingsLogic initialized');
  }
}
