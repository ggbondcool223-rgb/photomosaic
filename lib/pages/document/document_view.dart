import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final title = arguments?['title'] as String? ?? Lang.documentTitle;
    final content = arguments?['content'] as String? ?? Lang.documentContent;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: ScreenUtil().setWidth(20),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Text(
          content,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            color: Colors.black87,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
