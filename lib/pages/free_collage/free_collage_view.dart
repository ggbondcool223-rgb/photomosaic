import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'free_collage_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class FreeCollageView extends StatelessWidget {
  const FreeCollageView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<FreeCollageLogic>();
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
          Lang.templateSelectFree,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final containerWidth = constraints.maxWidth - ScreenUtil().setWidth(40);
          final containerHeight = constraints.maxHeight - ScreenUtil().setHeight(40);
          return Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
            ),
            child: Obx(() => logic.images.isEmpty
                ? Center(
                    child: ElevatedButton(
                      onPressed: () => logic.addImage(),
                      child: Text(
                        Lang.commonSelect,
                        style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                    child: Stack(
                      children: logic.images.asMap().entries.map((entry) {
                        final index = entry.key;
                        final image = entry.value;
                        final left = ((image['x'] as num).toDouble() * containerWidth).clamp(0.0, containerWidth);
                        final top = ((image['y'] as num).toDouble() * containerHeight).clamp(0.0, containerHeight);
                        final width = ((image['width'] as num).toDouble() * containerWidth).clamp(0.0, containerWidth - left);
                        final height = ((image['height'] as num).toDouble() * containerHeight).clamp(0.0, containerHeight - top);
                        return Positioned(
                          left: left,
                          top: top,
                          child: GestureDetector(
                            onPanUpdate: (details) => logic.updateImagePosition(
                              index,
                              details.delta.dx / containerWidth,
                              details.delta.dy / containerHeight,
                            ),
                            child: Container(
                              width: width,
                              height: height,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 2),
                              ),
                              child: image['path'] is String && image['path'].toString().startsWith('/')
                                  ? Image.file(
                                      File(image['path'] as String),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                          child: Icon(Icons.broken_image),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      image['path'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => logic.addImage(),
        child: Icon(Icons.add),
      ),
      ),
    );
  }
}
