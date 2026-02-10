import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'image_edit_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class ImageEditView extends StatelessWidget {
  const ImageEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ImageEditLogic>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppTheme.darkCard,
        systemNavigationBarColor: AppTheme.darkCard,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.darkBackground,
                AppTheme.darkSurface,
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: AppTheme.spacingL,
                  right: AppTheme.spacingL,
                  top: MediaQuery.of(context).padding.top + AppTheme.spacingM,
                  bottom: AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.primaryColor,
                        size: ScreenUtil().setWidth(20),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        Lang.imageEditTitle,
                        style: AppTheme.darkTitleStyle,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.successColor,
                            AppTheme.infoColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: ScreenUtil().setWidth(24),
                        ),
                        onPressed: () => logic.save(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() => Container(
                  margin: EdgeInsets.all(AppTheme.spacingL),
                  decoration: BoxDecoration(
                    color: AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: logic.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : logic.imagePath.isEmpty
                          ? Center(
                              child: Container(
                                decoration: AppTheme.gradientDecoration,
                                child: ElevatedButton(
                                  onPressed: () => logic.selectImage(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacingXL,
                                      vertical: AppTheme.spacingM,
                                    ),
                                  ),
                                  child: Text(
                                    Lang.commonSelect,
                                    style: AppTheme.darkBodyStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.radiusL),
                              child: Image.file(
                                File(logic.imagePath.value),
                                fit: BoxFit.contain,
                              ),
                            ),
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppTheme.spacingM,
                  horizontal: AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildToolButton(
                        icon: Icons.crop_square,
                        label: Lang.imageEditSquare,
                        color: AppTheme.menuColors[0],
                        onTap: () {},
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      _buildToolButton(
                        icon: Icons.filter,
                        label: Lang.imageEditFilter,
                        color: AppTheme.menuColors[1],
                        onTap: () => Get.toNamed('/filter_list'),
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      _buildToolButton(
                        icon: Icons.movie,
                        label: Lang.imageEditFilm,
                        color: AppTheme.menuColors[2],
                        onTap: () {},
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      _buildToolButton(
                        icon: Icons.texture,
                        label: Lang.imageEditTexture,
                        color: AppTheme.menuColors[3],
                        onTap: () {},
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      _buildToolButton(
                        icon: Icons.text_fields,
                        label: Lang.imageEditText,
                        color: AppTheme.menuColors[4],
                        onTap: () => Get.toNamed('/text_edit'),
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      _buildToolButton(
                        icon: Icons.favorite,
                        label: Lang.imageEditSticker,
                        color: AppTheme.menuColors[5],
                        onTap: () => Get.toNamed('/sticker_list'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setWidth(50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: color.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: ScreenUtil().setWidth(24),
            ),
          ),
          SizedBox(height: AppTheme.spacingS),
          Text(
            label,
            style: AppTheme.darkBodyStyle.copyWith(
              fontSize: AppTheme.fontSizeS,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
