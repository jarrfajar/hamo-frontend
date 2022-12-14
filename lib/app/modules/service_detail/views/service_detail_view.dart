import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/data/currency.dart';
import 'package:hamo/app/models/Service.dart';
import 'package:hamo/app/models/Service.dart' as service_model;
import 'package:hamo/app/models/confirmService.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../controllers/service_detail_controller.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  // var service = Get.arguments;
  int id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: controller.getService(id: id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              service_model.Service service = controller.listSerivce.first;
              return Stack(
                children: [
                  //align at bottom center using Align()
                  ListView(
                    padding: const EdgeInsets.only(bottom: 70),
                    children: [
                      // Container(
                      //   height: Get.height * 0.32,
                      //   color: Colors.red,
                      // ),
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: '${Api.domainUrl}/${service.image}',
                            imageBuilder: (context, imageProvider) => Container(
                              height: Get.height * 0.32,
                              // width: 120,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: const Color.fromARGB(255, 230, 230, 230),
                              highlightColor: Colors.white,
                              child: Container(
                                height: Get.height * 0.32,
                                // width: 120,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 236, 236, 236),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.title!,
                              style: const TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
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
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 24.0,
                                  color: Colors.yellow[700],
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '4.8 ',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: '(${service.comments!.length}'),
                                      const TextSpan(text: ' Reviews)'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(int.parse(service.price!)),
                              style: const TextStyle(
                                color: Color(0xff7210FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Divider(thickness: 1),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ReadMoreText(
                              service.description!,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                              trimLines: 3,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7210FF),
                              ),
                              lessStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7210FF),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff7210FF),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40.0,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.review.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      String review = controller.review[index];

                                      return Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            controller.current.value = index;

                                            controller.changeReview(service);
                                          },
                                          child: Container(
                                            width: 80.0,
                                            padding: const EdgeInsets.all(10.0),
                                            margin: const EdgeInsets.only(right: 10.0),
                                            decoration: BoxDecoration(
                                              color: controller.current.value == index
                                                  ? const Color(0xff7210FF)
                                                  : Colors.white,
                                              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                              border: Border.all(
                                                color: const Color(0xff7210FF),
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  size: 18.0,
                                                  // color: Colors.white, const Color(0xff7210ff)
                                                  color: controller.current.value == index
                                                      ? Colors.white
                                                      : const Color(0xff7210ff),
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  review,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    // color: Colors.white,
                                                    color: controller.current.value == index
                                                        ? Colors.white
                                                        : const Color(0xff7210ff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),

                                // BODY REVIEW
                                Obx(
                                  () => controller.current.value == 0 || controller.listReview.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: controller.current.value == 0
                                              ? service.comments!.length
                                              : controller.listReview.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            var comments = controller.current.value == 0
                                                ? service.comments![index]
                                                : controller.listReview[index];
                                            // var comments = controller.changeReview(service.comments!);

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // const CircleAvatar(
                                                        //   backgroundColor: Colors.blue,
                                                        // ),
                                                        ClipOval(
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: Colors.blue,
                                                            ),
                                                            child: Image.network(
                                                              comments.user!.profile?.image == null ||
                                                                      comments.user!.profile?.image == ''
                                                                  ? 'https://ui-avatars.com/api/?name=${comments.user!.name!}'
                                                                  : '${Api.domainUrl}/${comments.user!.profile?.image}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                          comments.user!.name!,
                                                          style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 60.0,
                                                      padding: const EdgeInsets.all(5.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                                        border: Border.all(
                                                          color: const Color(0xff7210FF),
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            size: 18.0,
                                                            // color: Colors.white, const Color(0xff7210ff)
                                                            color: Color(0xff7210ff),
                                                          ),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            comments.rating!,
                                                            style: const TextStyle(
                                                              fontSize: 16.0,
                                                              color: Color(0xff7210ff),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                ReadMoreText(
                                                  comments.description!,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                  trimLines: 3,
                                                  colorClickableText: Colors.pink,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: 'Show more',
                                                  trimExpandedText: 'Show less',
                                                  moreStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff7210FF),
                                                  ),
                                                  lessStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff7210FF),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(controller.converDate(comments.createdAt!.toString())),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : const Text("Nothing Review :("),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // BUTTON
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xfff1e7ff),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (service.favorite!.isEmpty) {
                                      controller.bookmark(id: service.id!);
                                    } else {
                                      controller.unbookmark(id: service.id!);
                                    }
                                  },
                                  child: controller.isBookmar.isTrue
                                      ? const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: Color(0xff7210FF),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              service.favorite!.isEmpty ? "Bookmar" : "Unbookmar",
                                              style: const TextStyle(
                                                color: Color(0xff7210FF),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            service.favorite!.isEmpty
                                                ? const Icon(
                                                    Icons.bookmark_add,
                                                    color: Color(0xff7210FF),
                                                    size: 24.0,
                                                  )
                                                : const Icon(
                                                    Icons.bookmark_remove_rounded,
                                                    color: Color(0xff7210FF),
                                                    size: 24.0,
                                                  ),
                                          ],
                                        ),
                                ),
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
                                onPressed: () => Get.toNamed(Routes.BOOKING_DETAILS, arguments: service),
                                child: controller.isLoading.isTrue
                                    ? const SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Book Now"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
