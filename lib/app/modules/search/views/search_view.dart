import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Service.dart';
import 'package:hamo/app/reusable/serviceCard.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          children: [
            // SEARCH BAR
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24.0,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
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
                            autofocus: true,
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
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),

            // BODY SEARCH
            Obx(
              () => controller.search.isEmpty && controller.first.isEmpty
                  ? const Center(child: Text("Tidak ada data :("))
                  : controller.first.isNotEmpty
                      ? Center(child: Text(controller.first.value))
                      : Column(
                          children: [
                            Row(
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
                            // HAPUS SINGLECHILD DAN UNCOMENT NEVERSCROLL
                            ListView.builder(
                              shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.search.length,
                              itemBuilder: (context, index) {
                                Service service = controller.search[index];

                                return ServiceCard(
                                  imgUrl: '${Api.domainUrl}/${service.image}',
                                  categoryName: service.category!.name!,
                                  title: service.title!,
                                  price: service.price!,
                                  // description: service.description!,
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
                                  icon: const Icon(
                                    Icons.bookmark,
                                    color: Color(0xff7210ff),
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
