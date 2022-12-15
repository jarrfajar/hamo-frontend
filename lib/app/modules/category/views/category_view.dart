import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Category.dart' as category_model;
import 'package:hamo/app/reusable/shimmer/category.dart';
import 'package:hamo/app/routes/app_pages.dart';

import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'All Service',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          FutureBuilder(
            future: controller.getCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerCategory();
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  childAspectRatio: 2 / 2,
                ),
                itemCount: controller.listCategory.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  category_model.Category category = controller.listCategory[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.DETAIL_CATEGORY,
                      arguments: category,
                    ),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 50,
                            width: 50,
                            // padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // child: const Icon(Icons.abc),
                            child: Image.network(
                              // 'https://ui-avatars.com/api/?name=Fajar+Yasin',
                              '${Api.domainUrl}/${category.img}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          category.name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
