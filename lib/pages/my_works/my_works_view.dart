import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'my_works_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class MyWorksView extends StatelessWidget {
  const MyWorksView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MyWorksLogic>();
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
                child: Text(
                  Lang.myWorksTitle,
                  style: AppTheme.titleStyle,
                ),
              ),
              Expanded(
                child: Obx(() => logic.works.isEmpty
                    ? Center(
                        child: Text(
                          Lang.myWorksEmpty,
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(AppTheme.spacingM),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppTheme.spacingM,
                          mainAxisSpacing: AppTheme.spacingM,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: logic.works.length,
                        itemBuilder: (context, index) {
                          final work = logic.works[index];
                          final colorIndex = index % AppTheme.menuColors.length;
                          return GestureDetector(
                            onTap: () => logic.previewWork(work.id!),
                            onLongPress: () => logic.showDeleteDialog(work.id!),
                            child: Container(
                              decoration: AppTheme.cardDecoration.copyWith(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.menuColors[colorIndex].withValues(alpha: 0.1),
                                    Colors.white,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(AppTheme.radiusM),
                                          topRight: Radius.circular(AppTheme.radiusM),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(AppTheme.spacingS),
                                    child: Text(
                                      work.name,
                                      style: AppTheme.bodyStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
}
