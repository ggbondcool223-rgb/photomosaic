import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';
import '../lang/lang.dart';
import 'logger.dart';

class PermissionUtil {
  static final permissionStatus = PermissionStatus.denied.obs;

  static Future<void> checkPermission() async {
    try {
      final photosStatus = await Permission.photos.status;
      final photoManagerStatus = await PhotoManager.requestPermissionExtend();
      
      PermissionStatus finalStatus;
      if (photoManagerStatus.isAuth) {
        if (photosStatus == PermissionStatus.granted) {
          finalStatus = PermissionStatus.granted;
        } else if (photosStatus == PermissionStatus.limited) {
          finalStatus = PermissionStatus.limited;
        } else {
          finalStatus = PermissionStatus.granted;
        }
      } else {
        finalStatus = photosStatus;
      }
      
      permissionStatus.value = finalStatus;
      Logger.d('Permission status: $finalStatus');
    } catch (e) {
      Logger.e('Failed to check permission', e);
      permissionStatus.value = PermissionStatus.denied;
    }
  }

  static Future<void> requestPermission() async {
    try {
      final photosStatus = await Permission.photos.request();
      await Future.delayed(const Duration(milliseconds: 500));
      final photoManagerStatus = await PhotoManager.requestPermissionExtend();
      
      PermissionStatus finalStatus;
      if (photoManagerStatus.isAuth) {
        finalStatus = photosStatus == PermissionStatus.limited 
            ? PermissionStatus.limited 
            : PermissionStatus.granted;
      } else {
        finalStatus = photosStatus;
      }
      
      permissionStatus.value = finalStatus;
      Logger.d('Permission requested, status: $finalStatus');
      
      if (finalStatus == PermissionStatus.permanentlyDenied) {
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      Logger.e('Failed to request permission', e);
      permissionStatus.value = PermissionStatus.denied;
    }
  }

  static Future<void> refreshPermission() async {
    await checkPermission();
  }

  static bool get isGranted {
    return permissionStatus.value == PermissionStatus.granted || 
           permissionStatus.value == PermissionStatus.limited;
  }

  static void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(Lang.permissionRequired),
        content: Text(Lang.permissionMessage),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Lang.permissionCancel),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text(Lang.permissionOpenSettings),
          ),
        ],
      ),
    );
  }
}
