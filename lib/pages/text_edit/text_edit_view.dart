import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'text_edit_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class TextEditView extends StatelessWidget {
  const TextEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<TextEditLogic>();
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
          Lang.textEditTitle,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: ScreenUtil().setWidth(24),
            ),
            onPressed: () => logic.save(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: Lang.textEditInput,
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) => logic.text.value = value,
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Text(
                Lang.textEditFont,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Obx(() => Wrap(
                spacing: ScreenUtil().setWidth(12),
                children: logic.fonts.map((font) {
                  return ChoiceChip(
                    label: Text(font),
                    selected: logic.selectedFont.value == font,
                    onSelected: (selected) => logic.selectedFont.value = font,
                  );
                }).toList(),
              )),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Text(
                Lang.textEditColor,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Obx(() => Wrap(
                spacing: ScreenUtil().setWidth(12),
                children: logic.colors.map((color) {
                  return GestureDetector(
                    onTap: () => logic.selectedColor.value = color,
                    child: Container(
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(40),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: logic.selectedColor.value == color
                              ? Colors.white
                              : Colors.transparent,
                          width: ScreenUtil().setWidth(2),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
