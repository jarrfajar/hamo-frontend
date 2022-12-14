import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/controllers/page_index_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
  final pageController = Get.put(PageIndexController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xffffffff)),
      // darkTheme: ThemeData.,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
