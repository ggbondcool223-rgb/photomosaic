import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0080FF);
  static const Color secondaryColor = Color(0xFFBF00FF);
  static const Color accentColor = Color(0xFFFF1493);
  static const Color successColor = Color(0xFF39FF14);
  static const Color warningColor = Color(0xFFFFAA00);
  static const Color infoColor = Color(0xFF00FFFF);
  
  static const Color darkBackground = Color(0xFF0F0F1E);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF252540);
  
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightCard = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF94A3B8);
  
  static const List<Color> gradientColors = [
    Color(0xFF0080FF),
    Color(0xFFBF00FF),
    Color(0xFFFF1493),
    Color(0xFFFFAA00),
  ];
  
  static const List<Color> menuColors = [
    Color(0xFF0080FF),
    Color(0xFFBF00FF),
    Color(0xFFFF1493),
    Color(0xFF00FFFF),
    Color(0xFFFFAA00),
    Color(0xFF39FF14),
  ];
  
  static double get spacingXS => ScreenUtil().setWidth(4);
  static double get spacingS => ScreenUtil().setWidth(8);
  static double get spacingM => ScreenUtil().setWidth(16);
  static double get spacingL => ScreenUtil().setWidth(24);
  static double get spacingXL => ScreenUtil().setWidth(32);
  
  static double get radiusS => ScreenUtil().radius(4);
  static double get radiusM => ScreenUtil().radius(8);
  static double get radiusL => ScreenUtil().radius(12);
  static double get radiusXL => ScreenUtil().radius(16);
  
  static double get fontSizeXS => ScreenUtil().setSp(10);
  static double get fontSizeS => ScreenUtil().setSp(12);
  static double get fontSizeM => ScreenUtil().setSp(14);
  static double get fontSizeL => ScreenUtil().setSp(16);
  static double get fontSizeXL => ScreenUtil().setSp(18);
  static double get fontSizeXXL => ScreenUtil().setSp(20);
  
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: lightCard,
    borderRadius: BorderRadius.circular(radiusM),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get darkCardDecoration => BoxDecoration(
    color: darkCard,
    borderRadius: BorderRadius.circular(radiusM),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.1),
      width: 1,
    ),
  );
  
  static BoxDecoration get gradientDecoration => BoxDecoration(
    gradient: LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radiusM),
  );
  
  static TextStyle get titleStyle => TextStyle(
    fontSize: fontSizeXL,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get subtitleStyle => TextStyle(
    fontSize: fontSizeL,
    fontWeight: FontWeight.w600,
    color: textSecondary,
  );
  
  static TextStyle get bodyStyle => TextStyle(
    fontSize: fontSizeM,
    color: textPrimary,
  );
  
  static TextStyle get captionStyle => TextStyle(
    fontSize: fontSizeS,
    color: textMuted,
  );
  
  static TextStyle get darkTitleStyle => TextStyle(
    fontSize: fontSizeXL,
    fontWeight: FontWeight.bold,
    color: textLight,
  );
  
  static TextStyle get darkBodyStyle => TextStyle(
    fontSize: fontSizeM,
    color: textLight,
  );
}
