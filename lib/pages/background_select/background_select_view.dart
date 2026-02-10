import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'background_select_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class BackgroundSelectView extends StatelessWidget {
  const BackgroundSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<BackgroundSelectLogic>();
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
          Lang.backgroundSelectTitle,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _buildTypeButton(Lang.backgroundColor, 'color', logic),
                ),
                SizedBox(width: ScreenUtil().setWidth(8)),
                Flexible(
                  child: _buildTypeButton(Lang.backgroundImage, 'image', logic),
                ),
                SizedBox(width: ScreenUtil().setWidth(8)),
                Flexible(
                  child: _buildTypeButton(Lang.backgroundTexture, 'texture', logic),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (logic.selectedType.value == 'color') {
                return GridView.builder(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: ScreenUtil().setWidth(12),
                    mainAxisSpacing: ScreenUtil().setWidth(12),
                    childAspectRatio: 1,
                  ),
                  itemCount: logic.colors.length,
                  itemBuilder: (context, index) {
                    final color = logic.colors[index];
                    return GestureDetector(
                      onTap: () => logic.selectColor(color),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: ScreenUtil().setWidth(2),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return GridView.builder(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: ScreenUtil().setWidth(12),
                    mainAxisSpacing: ScreenUtil().setWidth(12),
                    childAspectRatio: 0.8,
                  ),
                  itemCount: logic.backgrounds.length,
                  itemBuilder: (context, index) {
                    final bg = logic.backgrounds[index];
                    return GestureDetector(
                      onTap: () => logic.selectBackground(bg.id!),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String type, BackgroundSelectLogic logic) {
    return Obx(() => GestureDetector(
      onTap: () => logic.selectType(type),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: logic.selectedType.value == type
              ? Colors.white
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              color: logic.selectedType.value == type
                  ? Colors.black
                  : Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ));
  }
}
