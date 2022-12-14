import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/bookmarks.dart';
import 'package:hamo/app/reusable/serviceCard.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:hamo/app/routes/app_pages.dart';

import '../controllers/bookmark_controller.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({Key? key}) : super(key: key);
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
          'My Bookmark',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Expanded(
              child: Container(
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
                        // autofocus: true,
                        onChanged: (value) {
                          controller.searchChanged(value);
                        },
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
            ),
          ),
          FutureBuilder(
            future: controller.getBookmark(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerService();
              }
              return Obx(
                () => controller.listBookmarksSearch.isEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        itemCount: controller.listBookmarks.length,
                        itemBuilder: (context, index) {
                          Bookmarks bookmarks = controller.listBookmarks[index];

                          return GestureDetector(
                            onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: bookmarks.id),
                            child: ServiceCard(
                              // TAMBAHKAN USER
                              imgUrl: '${Api.domainUrl}/${bookmarks.image}',
                              categoryName: bookmarks.user!.name!,
                              title: bookmarks.title!,
                              price: bookmarks.price!,
                              // description: bookmarks.title!,
                              description: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xfff4ecff),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  bookmarks.category!.name!,
                                  style: const TextStyle(
                                    color: Color(0xff7210FF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              icon: GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      height: Get.height * 0.4,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          topRight: Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Container(
                                            height: 5,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[350],
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          const Text(
                                            'Remove from Bookmark?',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 10.0,
                                          // ),
                                          GestureDetector(
                                            onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: bookmarks.id),
                                            child: ServiceCard(
                                              imgUrl: '${Api.domainUrl}/${bookmarks.image}',
                                              categoryName: bookmarks.user!.name!,
                                              title: bookmarks.title!,
                                              price: bookmarks.price!,
                                              // description: bookmarks.description!,
                                              description: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xfff4ecff),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  bookmarks.category!.name!,
                                                  style: const TextStyle(
                                                    color: Color(0xff7210FF),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.bookmark_remove_rounded,
                                                color: Color(0xff7210ff),
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),

                                          // BOTTOM
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xfff1e7ff),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                    ),
                                                    onPressed: () => Get.back(),
                                                    child: (controller.isLoading.isTrue
                                                        ? const SizedBox(
                                                            height: 25,
                                                            width: 25,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 3,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                        : const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              color: Color(0xff7210FF),
                                                            ),
                                                          )),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xff7210FF),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                    ),
                                                    onPressed: () => controller.unbookmar(id: bookmarks.id.toString()),
                                                    child: controller.isLoading.isTrue
                                                        ? const SizedBox(
                                                            height: 25,
                                                            width: 25,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 3,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                        : const Text("Yes, Remove"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.bookmark,
                                  color: Color(0xff7210ff),
                                  size: 30,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    // SEARCH
                    : controller.count.value == '0' || controller.count.isEmpty
                        ? const Center(child: Text("tidak ada :("))
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Result for ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: controller.keyword.value,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Color(0xff7210FF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${controller.count.value} founds",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Color(0xff7210FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                shrinkWrap: true,
                                itemCount: controller.listBookmarksSearch.length,
                                itemBuilder: (context, index) {
                                  Bookmarks bookmarks = controller.listBookmarksSearch[index];

                                  return GestureDetector(
                                    onTap: () => Get.toNamed(Routes.SERVICE_DETAIL, arguments: bookmarks.id),
                                    child: ServiceCard(
                                      imgUrl: '${Api.domainUrl}/${bookmarks.image}',
                                      categoryName: bookmarks.user!.name!,
                                      title: bookmarks.title!,
                                      price: bookmarks.price!,
                                      // description: bookmarks.title!,
                                      description: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xfff4ecff),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          bookmarks.category!.name!,
                                          style: const TextStyle(
                                            color: Color(0xff7210FF),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      icon: GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              height: Get.height * 0.4,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(40.0),
                                                  topRight: Radius.circular(40.0),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Container(
                                                    height: 5,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[350],
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  const Text(
                                                    'Remove from Bookmark?',
                                                    style: TextStyle(
                                                      fontSize: 24.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 10.0,
                                                  // ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Get.toNamed(Routes.SERVICE_DETAIL, arguments: bookmarks.id),
                                                    child: ServiceCard(
                                                      imgUrl: '${Api.domainUrl}/${bookmarks.image}',
                                                      categoryName: bookmarks.user!.name!,
                                                      title: bookmarks.title!,
                                                      price: bookmarks.price!,
                                                      // description: bookmarks.description!,
                                                      description: Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xfff4ecff),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          bookmarks.category!.name!,
                                                          style: const TextStyle(
                                                            color: Color(0xff7210FF),
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      icon: const Icon(
                                                        Icons.bookmark_remove_rounded,
                                                        color: Color(0xff7210ff),
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15.0,
                                                  ),

                                                  // BOTTOM
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 50,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xfff1e7ff),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(50),
                                                              ),
                                                            ),
                                                            onPressed: () => Get.back(),
                                                            child: (controller.isLoading.isTrue
                                                                ? const SizedBox(
                                                                    height: 25,
                                                                    width: 25,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth: 3,
                                                                      color: Colors.white,
                                                                    ),
                                                                  )
                                                                : const Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                      color: Color(0xff7210FF),
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  )),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 50,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xff7210FF),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(50),
                                                              ),
                                                            ),
                                                            onPressed: () =>
                                                                controller.unbookmar(id: bookmarks.id.toString()),
                                                            child: controller.isLoading.isTrue
                                                                ? const SizedBox(
                                                                    height: 25,
                                                                    width: 25,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth: 3,
                                                                      color: Colors.white,
                                                                    ),
                                                                  )
                                                                : const Text("Yes, Remove"),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.bookmark,
                                          color: Color(0xff7210ff),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
              );
            },
          ),
        ],
      ),
    );
  }
}
