import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'template_select_logic.dart';
import '../../lang/lang.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/app_theme.dart';

class TemplateSelectView extends StatelessWidget {
  const TemplateSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<TemplateSelectLogic>();
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
                      child: Obx(() => Text(
                        '${Lang.templateSelectTitle} (${logic.totalCount.value})',
                        style: AppTheme.darkTitleStyle,
                      )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() => GridView.builder(
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppTheme.spacingS,
                    mainAxisSpacing: AppTheme.spacingS,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: logic.templates.length,
                  itemBuilder: (context, index) {
                    final template = logic.templates[index];
                    final colorIndex = index % AppTheme.menuColors.length;
                    return GestureDetector(
                      onTap: () => logic.selectTemplate(template.id!),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.menuColors[colorIndex].withValues(alpha: 0.3),
                              AppTheme.menuColors[colorIndex].withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          border: Border.all(
                            color: AppTheme.menuColors[colorIndex].withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.menuColors[colorIndex].withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppTheme.spacingXS),
                          child: template.type == 'free'
                              ? Center(
                                  child: Text(
                                    Lang.templateSelectFree,
                                    style: AppTheme.darkBodyStyle.copyWith(
                                      fontSize: AppTheme.fontSizeXS,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : template.type == 'long'
                                  ? Center(
                                      child: Text(
                                        Lang.templateSelectLong,
                                        style: AppTheme.darkBodyStyle.copyWith(
                                          fontSize: AppTheme.fontSizeXS,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : _buildLayoutPreview(template),
                        ),
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutPreview(TemplateEntity template) {
    try {
      final layoutData = json.decode(template.layoutData) as Map<String, dynamic>;
      final slots = layoutData['slots'] as List<dynamic>?;
      
      if (slots == null || slots.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;
          return CustomPaint(
            size: Size(size, size),
            painter: LayoutPreviewPainter(slots: slots),
          );
        },
      );
    } catch (e) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
      );
    }
  }
}

class LayoutPreviewPainter extends CustomPainter {
  final List<dynamic> slots;

  LayoutPreviewPainter({required this.slots});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var slot in slots) {
      final x = (slot['x'] as num).toDouble() * size.width;
      final y = (slot['y'] as num).toDouble() * size.height;
      final width = (slot['width'] as num).toDouble() * size.width;
      final height = (slot['height'] as num).toDouble() * size.height;

      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LayoutPreviewPainter oldDelegate) {
    return oldDelegate.slots != slots;
  }
}
