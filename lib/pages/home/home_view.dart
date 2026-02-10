import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'home_logic.dart';
import '../../lang/lang.dart';
import '../../utils/app_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<HomeLogic>();
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
          child: SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          Lang.homeTitle,
                          style: AppTheme.titleStyle.copyWith(
                            fontSize: AppTheme.fontSizeXXL,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: ScreenUtil().setWidth(24),
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: () => logic.onSettingsTap(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                  child: _buildImageCard(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                  ),
                  child: _buildMenuGrid(logic),
                ),
                SizedBox(height: AppTheme.spacingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      decoration: AppTheme.cardDecoration.copyWith(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/home_card.png',
              width: double.infinity,
              height: ScreenUtil().setHeight(220),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: ScreenUtil().setHeight(220),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(40),
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(HomeLogic logic) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final spacing = AppTheme.spacingM;
        final itemWidth = (availableWidth - spacing) / 2;
        final iconSize = ScreenUtil().setWidth(70);
        final textHeight = AppTheme.fontSizeM * 1.3;
        final spacingHeight = AppTheme.spacingM;
        final padding = AppTheme.spacingM;
        final itemHeight = iconSize + spacingHeight + textHeight + padding * 2;
        final aspectRatio = itemWidth / itemHeight;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: logic.menuItems.length,
          itemBuilder: (context, index) {
            final item = logic.menuItems[index];
            return GestureDetector(
              onTap: () => logic.onMenuTap(index),
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration: AppTheme.cardDecoration.copyWith(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item['color'] as Color,
                      (item['color'] as Color).withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (item['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: Colors.white,
                          size: ScreenUtil().setWidth(36),
                        ),
                      ),
                    ),
                    SizedBox(height: spacingHeight),
                    Flexible(
                      child: Text(
                        item['title'] as String,
                        style: AppTheme.bodyStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.fontSizeM,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
