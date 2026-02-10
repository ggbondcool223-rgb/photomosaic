import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'sticker_list_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class StickerListView extends StatelessWidget {
  const StickerListView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StickerListLogic>();
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
          Lang.stickerListTitle,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(50),
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              itemCount: logic.categories.length,
              itemBuilder: (context, index) {
                final category = logic.categories[index];
                return Obx(() => GestureDetector(
                  onTap: () => logic.selectCategory(category),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(16),
                      vertical: ScreenUtil().setHeight(8),
                    ),
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                    decoration: BoxDecoration(
                      color: logic.selectedCategory.value == category
                          ? Colors.white
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: logic.selectedCategory.value == category
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ));
              },
            )),
          ),
          Expanded(
            child: Obx(() => GridView.builder(
              padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: ScreenUtil().setWidth(12),
                mainAxisSpacing: ScreenUtil().setWidth(12),
                childAspectRatio: 1,
              ),
              itemCount: logic.stickers.length,
              itemBuilder: (context, index) {
                final sticker = logic.stickers[index];
                return GestureDetector(
                  onTap: () => logic.selectSticker(sticker.id!),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: ScreenUtil().setWidth(30),
                      ),
                    ),
                  ),
                );
              },
            )),
          ),
        ],
      ),
      ),
    );
  }
}
