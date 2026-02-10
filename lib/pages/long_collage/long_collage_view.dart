import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'long_collage_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class LongCollageView extends StatelessWidget {
  const LongCollageView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<LongCollageLogic>();
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
          Lang.templateSelectLong,
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
      body: Obx(() => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          ),
          child: logic.images.isEmpty
              ? Container(
                  height: ScreenUtil().setHeight(200),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => logic.addImage(),
                    child: Text(
                      Lang.commonSelect,
                      style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                    ),
                  ),
                )
              : Column(
                  children: logic.images.asMap().entries.map((entry) {
                    final index = entry.key;
                    final imagePath = entry.value;
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(4)),
                      child: Stack(
                        children: [
                          imagePath.startsWith('/')
                              ? Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: ScreenUtil().setHeight(200),
                                      color: Colors.grey,
                                      child: Icon(Icons.broken_image),
                                    );
                                  },
                                )
                              : Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                          Positioned(
                            top: ScreenUtil().setHeight(8),
                            right: ScreenUtil().setWidth(8),
                            child: GestureDetector(
                              onTap: () => logic.removeImage(index),
                              child: Container(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => logic.addImage(),
        child: Icon(Icons.add),
      ),
      ),
    );
  }
}
