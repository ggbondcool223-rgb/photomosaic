import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'db_photo_mosaic/data.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/template_select/template_select_binding.dart';
import '../pages/template_select/template_select_view.dart';
import '../pages/collage_edit/collage_edit_binding.dart';
import '../pages/collage_edit/collage_edit_view.dart';
import '../pages/free_collage/free_collage_binding.dart';
import '../pages/free_collage/free_collage_view.dart';
import '../pages/long_collage/long_collage_binding.dart';
import '../pages/long_collage/long_collage_view.dart';
import '../pages/poster_collage/poster_collage_binding.dart';
import '../pages/poster_collage/poster_collage_view.dart';
import '../pages/image_edit/image_edit_binding.dart';
import '../pages/image_edit/image_edit_view.dart';
import '../pages/beauty/beauty_binding.dart';
import '../pages/beauty/beauty_view.dart';
import '../pages/filter_list/filter_list_binding.dart';
import '../pages/filter_list/filter_list_view.dart';
import '../pages/text_edit/text_edit_binding.dart';
import '../pages/text_edit/text_edit_view.dart';
import '../pages/sticker_list/sticker_list_binding.dart';
import '../pages/sticker_list/sticker_list_view.dart';
import '../pages/background_select/background_select_binding.dart';
import '../pages/background_select/background_select_view.dart';
import '../pages/frame_adjust/frame_adjust_binding.dart';
import '../pages/frame_adjust/frame_adjust_view.dart';
import '../pages/my_works/my_works_binding.dart';
import '../pages/my_works/my_works_view.dart';
import '../pages/album/album_binding.dart';
import '../pages/album/album_view.dart';
import '../pages/image_preview/image_preview_binding.dart';
import '../pages/image_preview/image_preview_view.dart';
import '../pages/settings/settings_binding.dart';
import '../pages/settings/settings_view.dart';
import '../pages/document/document_binding.dart';
import '../pages/document/document_view.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DbPhotoMosaicData.initData();
    Logger.i('App initialized successfully');
  } catch (e) {
    Logger.e('Failed to initialize app', e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Photo collage',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          initialRoute: '/home',
          getPages:Collage,
        );
      },
    );
  }
}
List<GetPage<dynamic>> Collage = [
  GetPage(
    name: '/home',
    page: () => const HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/template_select',
    page: () => const TemplateSelectView(),
    binding: TemplateSelectBinding(),
  ),
  GetPage(
    name: '/collage_edit',
    page: () => const CollageEditView(),
    binding: CollageEditBinding(),
  ),
  GetPage(
    name: '/free_collage',
    page: () => const FreeCollageView(),
    binding: FreeCollageBinding(),
  ),
  GetPage(
    name: '/long_collage',
    page: () => const LongCollageView(),
    binding: LongCollageBinding(),
  ),
  GetPage(
    name: '/poster_collage',
    page: () => const PosterCollageView(),
    binding: PosterCollageBinding(),
  ),
  GetPage(
    name: '/image_edit',
    page: () => const ImageEditView(),
    binding: ImageEditBinding(),
  ),
  GetPage(
    name: '/beauty',
    page: () => const BeautyView(),
    binding: BeautyBinding(),
  ),
  GetPage(
    name: '/filter_list',
    page: () => const FilterListView(),
    binding: FilterListBinding(),
  ),
  GetPage(
    name: '/text_edit',
    page: () => const TextEditView(),
    binding: TextEditBinding(),
  ),
  GetPage(
    name: '/sticker_list',
    page: () => const StickerListView(),
    binding: StickerListBinding(),
  ),
  GetPage(
    name: '/background_select',
    page: () => const BackgroundSelectView(),
    binding: BackgroundSelectBinding(),
  ),
  GetPage(
    name: '/frame_adjust',
    page: () => const FrameAdjustView(),
    binding: FrameAdjustBinding(),
  ),
  GetPage(
    name: '/my_works',
    page: () => const MyWorksView(),
    binding: MyWorksBinding(),
  ),
  GetPage(
    name: '/album',
    page: () => const AlbumView(),
    binding: AlbumBinding(),
  ),
  GetPage(
    name: '/image_preview',
    page: () => const ImagePreviewView(),
    binding: ImagePreviewBinding(),
  ),
  GetPage(
    name: '/settings',
    page: () => const SettingsView(),
    binding: SettingsBinding(),
  ),
  GetPage(
    name: '/document',
    page: () => const DocumentView(),
    binding: DocumentBinding(),
  ),
];