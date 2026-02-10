import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'image_preview_logic.dart';
import '../../lang/lang.dart';

class ImagePreviewView extends StatelessWidget {
  const ImagePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ImagePreviewLogic>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: ScreenUtil().setWidth(24),
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          logic.imagePath.isNotEmpty ? logic.imagePath.split('/').last : Lang.imagePreviewTitle,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        actions: [
          Obx(() => logic.imagePath.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: ScreenUtil().setWidth(24),
                  ),
                  onPressed: () => logic.showDeleteDialog(),
                )
              : SizedBox.shrink()),
        ],
      ),
      body: Obx(() => logic.imagePath.isEmpty
          ? Center(
              child: Text(
                Lang.imagePreviewError,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
            )
          : PhotoView(
              imageProvider: FileImage(File(logic.imagePath.value)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: ScreenUtil().setWidth(60),
                        color: Colors.white,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(16)),
                      Text(
                        Lang.imagePreviewError,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, event) {
                return Center(
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                );
              },
            )),
      ),
    );
  }
}
