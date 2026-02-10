import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'collage_edit_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class CollageEditView extends StatelessWidget {
  const CollageEditView({super.key});

  BoxDecoration get _topBottomBarDecoration => BoxDecoration(
    color: AppTheme.darkCard,
    border: Border(
      bottom: BorderSide(
        color: AppTheme.primaryColor.withValues(alpha: 0.3),
        width: 2,
      ),
    ),
  );

  BoxDecoration get _bottomBarDecoration => BoxDecoration(
    color: AppTheme.darkCard,
    border: Border(
      top: BorderSide(
        color: AppTheme.primaryColor.withValues(alpha: 0.3),
        width: 2,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CollageEditLogic>();
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
                  left: AppTheme.spacingM,
                  right: AppTheme.spacingM,
                  top: MediaQuery.of(context).padding.top + AppTheme.spacingS,
                  bottom: AppTheme.spacingS,
                ),
                decoration: _topBottomBarDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppTheme.primaryColor,
                        size: ScreenUtil().setWidth(24),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: ElevatedButton(
                            onPressed: () => logic.switchLayout(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingM,
                                vertical: AppTheme.spacingS,
                              ),
                            ),
                            child: Text(
                              Lang.collageEditSwitchLayout,
                              style: AppTheme.darkBodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: logic.selectedSlotIndex.value >= 0 && 
                        logic.selectedSlotIndex.value < logic.imageSlots.length &&
                        !logic.imageSlots[logic.selectedSlotIndex.value].isEmpty
                            ? AppTheme.accentColor
                            : AppTheme.textMuted,
                        size: ScreenUtil().setWidth(24),
                      ),
                      onPressed: logic.selectedSlotIndex.value >= 0 && 
                      logic.selectedSlotIndex.value < logic.imageSlots.length &&
                      !logic.imageSlots[logic.selectedSlotIndex.value].isEmpty
                          ? () => logic.deleteImageSlot(logic.selectedSlotIndex.value)
                          : null,
                    )),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() => Container(
                  margin: EdgeInsets.all(AppTheme.spacingL),
                  decoration: BoxDecoration(
                    color: logic.backgroundColor.value,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: logic.imageSlots.isEmpty
                      ? Center(
                          child: Text(
                            Lang.commonSelect,
                            style: AppTheme.darkBodyStyle.copyWith(
                              color: AppTheme.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : _buildLayoutCanvas(logic),
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildBottomButton(
                        icon: Icons.crop_free,
                        label: Lang.collageEditAdjustFrame,
                        color: AppTheme.infoColor,
                        onTap: () => logic.goToFrameAdjust(),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _buildBottomButton(
                        icon: Icons.palette,
                        label: Lang.collageEditSelectBackground,
                        color: AppTheme.warningColor,
                        onTap: () => logic.goToBackgroundSelect(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                decoration: _bottomBarDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      icon: Icons.arrow_back_ios,
                      color: AppTheme.textMuted,
                      onPressed: () => Get.back(),
                    ),
                    Obx(() => _buildIconButton(
                      icon: logic.isLoading.value ? null : Icons.check,
                      color: AppTheme.successColor,
                      isLoading: logic.isLoading.value,
                      onPressed: logic.isLoading.value ? null : () => logic.saveWork(),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutCanvas(CollageEditLogic logic) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = constraints.maxHeight;
        final spacing = logic.frameSpacing.value;
        
        return Stack(
          children: logic.imageSlots.asMap().entries.map((entry) {
            final index = entry.key;
            final slot = entry.value;
            final x = slot.x * canvasWidth + spacing;
            final y = slot.y * canvasHeight + spacing;
            final width = slot.width * canvasWidth - spacing * 2;
            final height = slot.height * canvasHeight - spacing * 2;
            final isSelected = logic.selectedSlotIndex.value == index;
            
            return Positioned(
              left: x,
              top: y,
              width: width,
              height: height,
              child: GestureDetector(
                onTap: () => logic.selectImageSlot(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: slot.isEmpty
                          ? AppTheme.warningColor
                          : isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                      width: ScreenUtil().setWidth(slot.isEmpty || isSelected ? 3 : 0),
                    ),
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().radius(logic.frameRadius.value),
                    ),
                    color: slot.isEmpty ? AppTheme.warningColor.withValues(alpha: 0.1) : Colors.transparent,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().radius(logic.frameRadius.value),
                    ),
                    child: slot.isEmpty
                        ? Center(
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: ScreenUtil().setWidth(40),
                              color: AppTheme.warningColor,
                            ),
                          )
                        : slot.imagePath != null
                            ? Image.file(
                                File(slot.imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: ScreenUtil().setWidth(40),
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container(),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: ScreenUtil().setWidth(20)),
            SizedBox(width: AppTheme.spacingS),
            Flexible(
              child: Text(
                label,
                style: AppTheme.darkBodyStyle.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    IconData? icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return IconButton(
      icon: isLoading
          ? SizedBox(
              width: ScreenUtil().setWidth(24),
              height: ScreenUtil().setWidth(24),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          : Icon(icon, size: ScreenUtil().setWidth(24)),
      color: color,
      onPressed: onPressed,
    );
  }
}
