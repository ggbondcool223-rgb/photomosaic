import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'settings_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SettingsLogic>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppTheme.lightCard,
        systemNavigationBarColor: AppTheme.lightBackground,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.lightBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightBackground,
                AppTheme.lightSurface,
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
                  color: AppTheme.lightCard,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                      child: Text(
                        Lang.settingsTitle,
                        style: AppTheme.titleStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  itemCount: logic.menuItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacingS),
                  itemBuilder: (context, index) {
                    final item = logic.menuItems[index];
                    final colorIndex = index % AppTheme.menuColors.length;
                    return Container(
                      decoration: AppTheme.cardDecoration,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingS,
                        ),
                        leading: Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.menuColors[colorIndex],
                                AppTheme.menuColors[colorIndex].withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: ScreenUtil().setWidth(20),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          item['title'] as String,
                          style: AppTheme.bodyStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: ScreenUtil().setWidth(20),
                          color: AppTheme.menuColors[colorIndex],
                        ),
                        onTap: () => logic.onItemTap(item['action'] as String),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: AppTheme.spacingL,
                ),
                child: Text(
                  '${Lang.settingsVersion}: ${Lang.settingsVersionValue}',
                  textAlign: TextAlign.center,
                  style: AppTheme.captionStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
