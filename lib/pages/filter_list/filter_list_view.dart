import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'filter_list_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class FilterListView extends StatelessWidget {
  const FilterListView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<FilterListLogic>();
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
          Lang.filterListTitle,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
              itemCount: logic.filters.length,
              itemBuilder: (context, index) {
                final filter = logic.filters[index];
                return ListTile(
                  leading: Container(
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                    ),
                  ),
                  title: Text(
                    filter.entity.name,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: SizedBox(
                    width: ScreenUtil().setWidth(150),
                    child: Obx(() => Slider(
                      value: filter.intensity.value,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) => filter.intensity.value = value,
                    )),
                  ),
                );
              },
            )),
          ),
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Lang.filterIntensity,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(() => Text(
                  '${(logic.selectedIntensity.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Colors.white,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
