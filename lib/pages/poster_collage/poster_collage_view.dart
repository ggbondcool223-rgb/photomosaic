import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'poster_collage_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class PosterCollageView extends StatelessWidget {
  const PosterCollageView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<PosterCollageLogic>();
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
          Lang.posterCollageTitle,
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
      body: Obx(() => Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
        ),
        child: logic.images.isEmpty
            ? Center(
                child: ElevatedButton(
                  onPressed: () => logic.addImage(),
                  child: Text(
                    Lang.commonSelect,
                    style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                  ),
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: ScreenUtil().setWidth(8),
                  mainAxisSpacing: ScreenUtil().setWidth(8),
                  childAspectRatio: 0.8,
                ),
                itemCount: logic.images.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    logic.images[index],
                    fit: BoxFit.cover,
                  );
                },
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
