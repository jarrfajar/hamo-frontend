import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/controllers/page_index_controller.dart';
import 'package:hamo/app/models/Category.dart';
import 'package:hamo/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:hamo/app/reusable/navigationBar.dart';
import 'package:hamo/app/reusable/serviceCard.dart';
import 'package:hamo/app/reusable/shimmer/category.dart';
import 'package:hamo/app/reusable/shimmer/categoryHorizontal.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:hamo/app/models/Service.dart' as service_model;
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final PageIndexController pageController = Get.find();

  @override
  Widget build(BuildContext context) {
    // var inputFormat = DateFormat('yyyy-MM-dd');
    // var inputDate = inputFormat.parse('2022-12-02 00:00:00.000'); // <-- dd/MM 24H format

    // var outputFormat = DateFormat('dd MMM, yyyy hh:mm a');
    // var outputDate = outputFormat.format(inputDate);
    // print(outputDate);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // const CircleAvatar(),
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        // padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.network(
                          'https://ui-avatars.com/api/?name=Fajar+Yasin',
                          // '${Api.domainUrl}/${category.img}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.username.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.BOOKMARK),
                  child: const Icon(
                    Icons.bookmark,
                    size: 30,
                    color: Color(0xff7210ff),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),

            // SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: const BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextFormField(
                      onTap: () => Get.toNamed(Routes.SEARCH),
                      readOnly: true,
                      initialValue: null,
                      decoration: const InputDecoration.collapsed(
                        filled: true,
                        fillColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        hintText: "Search",
                      ),
                      onFieldSubmitted: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),

            // SERVICE CATEGORY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.CATEGORY),
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xff7210FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),

            // SERVICE CATEGORY MENU
            FutureBuilder(
              future: controller.getCategoryService(),
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
                  itemCount: 8,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    Category category = controller.listTestCategory[index];

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
            const SizedBox(
              height: 20.0,
            ),

            // MOST POPULAR SERVICE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Most Popular Service',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xff7210FF),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),

            // MOST POPULAR SERVICE MENU
            Column(
              children: [
                // CATEGORY
                Obx(
                  () => controller.isLoading.isTrue
                      ? ShimmerCategoryHorizontal()
                      : SizedBox(
                          height: 40.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.listCategory.length,
                            itemBuilder: (context, index) {
                              Category category = controller.listCategory[index];

                              return Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    controller.current.value = index;
                                    controller.show(category.id ?? 0);
                                  },
                                  child: Container(
                                    width: 80.0,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      color: controller.current.value == index ? const Color(0xff7210FF) : Colors.white,
                                      border: Border.all(
                                        color: const Color(0xff7210FF),
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.name!,
                                        style: TextStyle(
                                          color: controller.current.value == index
                                              ? Colors.white
                                              : const Color(0xff7210ff),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),

                // GetBuilder<BookmarkController>(builder: (controller) => ,)

                // SERVICE
                FutureBuilder(
                  future: controller.getService(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ShimmerService();
                    }

                    return Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.dataku.isEmpty
                            ? controller.listSerivce.length >= 5
                                ? 5
                                : controller.listSerivce.length
                            : controller.dataku.length >= 5
                                ? 5
                                : controller.dataku.length,
                        itemBuilder: (context, index) {
                          service_model.Service service =
                              controller.dataku.isEmpty ? controller.listSerivce[index] : controller.dataku[index];

                          return GestureDetector(
                            // onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: service),
                            onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: service.id),
                            child: ServiceCard(
                              imgUrl: '${Api.domainUrl}/${service.image}',
                              categoryName: service.user!.name!,
                              title: service.title!,
                              price: service.price!,
                              description: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xfff4ecff),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service.category!.name!,
                                  style: const TextStyle(
                                    color: Color(0xff7210FF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // description: service.category!.name!,
                              icon: service.favorite!.isEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.bookmark(id: service.id!, status: false, index: index);
                                      },
                                      child: controller.isBookmar.isFalse
                                          ? const Icon(
                                              Icons.bookmark_border,
                                              color: Color(0xff7210ff),
                                              size: 30,
                                            )
                                          : const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        controller.unBookmark(id: service.id!, status: false, index: index);
                                      },
                                      child: controller.isUnBookmar.isFalse
                                          ? const Icon(
                                              Icons.bookmark,
                                              color: Color(0xff7210ff),
                                              size: 30,
                                            )
                                          : const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                    ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),

      // BOTTOM NAVIGASI
      bottomNavigationBar: NavagationBar(
        controller: pageController.index.value,
        onChanged: (i) => pageController.changePage(i),
      ),
    );
  }
}
