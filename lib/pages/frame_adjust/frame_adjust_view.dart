import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'frame_adjust_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class FrameAdjustView extends StatelessWidget {
  const FrameAdjustView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<FrameAdjustLogic>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppTheme.darkCard,
        systemNavigationBarColor: AppTheme.darkCard,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.darkCard,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: ScreenUtil().setWidth(20),
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            Lang.frameAdjustTitle,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              color: Colors.white,
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Lang.frameStyle,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Obx(() => Wrap(
                spacing: ScreenUtil().setWidth(12),
                children: logic.styles.map((style) {
                  return ChoiceChip(
                    label: Text(style),
                    selected: logic.selectedStyle.value == style,
                    onSelected: (selected) => logic.selectedStyle.value = style,
                  );
                }).toList(),
              )),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Text(
                Lang.frameSpacing,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Obx(() => Column(
                children: [
                  Slider(
                    value: logic.spacing.value,
                    min: 0.0,
                    max: 20.0,
                    onChanged: (value) => logic.spacing.value = value,
                  ),
                  Text(
                    logic.spacing.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Text(
                Lang.frameRadius,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Obx(() => Column(
                children: [
                  Slider(
                    value: logic.radius.value,
                    min: 0.0,
                    max: 20.0,
                    onChanged: (value) => logic.radius.value = value,
                  ),
                  Text(
                    logic.radius.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
