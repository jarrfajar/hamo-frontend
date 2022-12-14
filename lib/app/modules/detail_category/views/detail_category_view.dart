import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Category.dart' as category_model;
import 'package:hamo/app/reusable/serviceCard.dart';
import 'package:hamo/app/routes/app_pages.dart';

import '../controllers/detail_category_controller.dart';

class DetailCategoryView extends GetView<DetailCategoryController> {
  category_model.Category category = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          category.name!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: category.services!.isEmpty
          ? const Center(child: Text("Tidak ada dataaaa :("))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shrinkWrap: true,
              itemCount: category.services!.length,
              itemBuilder: (context, index) {
                var data = category.services![index];

                return GestureDetector(
                  // onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: category.services),
                  onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: data.id),
                  child: ServiceCard(
                    imgUrl: '${Api.domainUrl}/${data.image}',
                    categoryName: data.user!.name!,
                    title: data.title!,
                    price: data.price!,
                    // description: data.title!,
                    description: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xfff4ecff),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category.name!,
                        style: const TextStyle(
                          color: Color(0xff7210FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    icon: data.favorite!.isNotEmpty
                        ? const Icon(
                            Icons.bookmark,
                            color: Color(0xff7210ff),
                            size: 30,
                          )
                        : const Icon(
                            Icons.bookmark_border,
                            color: Color(0xff7210ff),
                            size: 30,
                          ),
                  ),
                );
              },
            ),
    );
  }
}
