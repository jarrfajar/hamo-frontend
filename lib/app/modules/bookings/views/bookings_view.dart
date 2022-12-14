import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/controllers/page_index_controller.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:hamo/app/reusable/bookingCard.dart';
import 'package:hamo/app/reusable/navigationBar.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {
  final PageIndexController pageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            'My Bookings',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Color(0xff7210ff),
              unselectedLabelColor: Color(0xff9e9e9e),
              indicatorColor: Color(0xff7210ff),
              indicatorWeight: 3.0,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
            Expanded(
              child: GetBuilder<BookingsController>(
                builder: (_) {
                  return TabBarView(
                    children: [
                      BookingsBody(
                        controller: controller,
                        status: 'Upcoming',
                        bgColor: const Color(0xff7210ff),
                      ),
                      BookingsBody(
                        controller: controller,
                        status: 'Completed',
                        bgColor: const Color(0xff4aaf57),
                      ),
                      BookingsBody(
                        controller: controller,
                        status: 'Cancelled',
                        bgColor: Colors.redAccent,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),

        // BOTTOM NAVIGASI
        bottomNavigationBar: NavagationBar(
          controller: pageController.index.value,
          onChanged: (i) => pageController.changePage(i),
        ),
      ),
    );
  }
}

// BODY
class BookingsBody extends StatelessWidget {
  const BookingsBody({
    Key? key,
    required this.controller,
    required this.status,
    required this.bgColor,
  }) : super(key: key);

  final BookingsController controller;
  final String status;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        FutureBuilder(
          future: controller.getBooking(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerService();
            }

            var data = controller.bookings.where((element) => element.status == status).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                Receipt bookings = data[index];

                var inputFormat = DateFormat('yyyy-MM-dd');
                var inputDate = inputFormat.parse(bookings.date!);
                var outputFormat = DateFormat('dd MMM, yyyy');
                var outputDate = outputFormat.format(inputDate);

                return ExpandableNotifier(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 235, 235, 235),
                          blurRadius: 20,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: '${Api.domainUrl}/${bookings.service!.image}',
                                    imageBuilder: (context, imageProvider) => Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(20),
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
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 236, 236, 236),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookings.service!.title!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          bookings.user!.name!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            bookings.status!,
                                            style: const TextStyle(
                                              color: Color(0xfff1e7ff),
                                              // color: Color(0xff7210ff),
                                            ),
                                          ),
                                        ),
                                        bookings.status == 'Upcoming' && bookings.confirm == 'Confirmed'
                                            ? Column(
                                                children: const [
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "your booking has been confirmed",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff7210ff),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        bookings.status == 'Upcoming' && bookings.confirm == null
                                            ? Column(
                                                children: const [
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "Menunggu konfirmasi pesanan",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff7210ff),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        bookings.status == 'Upcoming' && bookings.confirm == 'Completed'
                                            ? Column(
                                                children: const [
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "service is complete?",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff7210ff),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        bookings.confirm == 'cancell'
                                            ? Column(
                                                children: const [
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "Your booking is canceled by tukang",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff7210ff),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        const SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        const Divider(
                          thickness: 2,
                          color: Color(0xffeeeeee),
                        ),
                        Expandable(
                          collapsed: ExpandableButton(
                            child: const RotatedBox(
                              quarterTurns: -3,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 24.0,
                                color: Color(0xff7210ff),
                              ),
                            ),
                          ),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BookingsCard(
                                valueDate: '$outputDate | ${bookings.time!}',
                                valueHours: '${bookings.hours!} Hours',
                                valueDescription: bookings.description!,
                                valueAddress: bookings.address!,
                              ),
                              const SizedBox(height: 10.0),
                              bookings.status! == 'Upcoming' && bookings.confirm == null
                                  ? Row(
                                      children: [
                                        // CANCEL
                                        bookings.confirm == null
                                            ? Expanded(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xfff1e7ff),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                    ),
                                                    onPressed: () => Get.bottomSheet(
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        height: Get.height * 0.3,
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
                                                              'Cancel Booking?',
                                                              style: TextStyle(
                                                                fontSize: 22.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.redAccent,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10.0),
                                                            const Divider(
                                                              thickness: 2,
                                                              color: Color(0xffeeeeee),
                                                            ),
                                                            const SizedBox(height: 10.0),
                                                            const Center(
                                                              child: Text(
                                                                "Are you sure want to cancel your service booking?",
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 30.0),

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
                                                                      child: const Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                          color: Color(0xff7210FF),
                                                                          fontWeight: FontWeight.bold,
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
                                                                      onPressed: () {
                                                                        controller.cancelBooking(
                                                                            id: bookings.id!.toString());
                                                                      },
                                                                      child: controller.isLoading.isTrue
                                                                          ? const SizedBox(
                                                                              height: 25,
                                                                              width: 25,
                                                                              child: CircularProgressIndicator(
                                                                                strokeWidth: 3,
                                                                                color: Colors.white,
                                                                              ),
                                                                            )
                                                                          : const Text("Yes, Cancel Booking"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
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
                                                            "Cancel Booking",
                                                            style: TextStyle(
                                                              color: Color(0xff7210FF),
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )),
                                                  ),
                                                ),
                                              )
                                            // CONFIRM
                                            : Expanded(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xfff1e7ff),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                    ),
                                                    onPressed: () => Get.bottomSheet(
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        height: Get.height * 0.3,
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
                                                              'Confirm Booking?',
                                                              style: TextStyle(
                                                                fontSize: 22.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.redAccent,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10.0),
                                                            const Divider(
                                                              thickness: 2,
                                                              color: Color(0xffeeeeee),
                                                            ),
                                                            const SizedBox(height: 10.0),
                                                            const Center(
                                                              child: Text(
                                                                "Are you sure want to confirm your service booking?",
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 30.0),

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
                                                                      child: const Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                          color: Color(0xff7210FF),
                                                                          fontWeight: FontWeight.bold,
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
                                                                      onPressed: () {
                                                                        // controller.cancelBooking(
                                                                        //     id: bookings.id!.toString());
                                                                        print('konfirmasi');
                                                                      },
                                                                      child: controller.isLoading.isTrue
                                                                          ? const SizedBox(
                                                                              height: 25,
                                                                              width: 25,
                                                                              child: CircularProgressIndicator(
                                                                                strokeWidth: 3,
                                                                                color: Colors.white,
                                                                              ),
                                                                            )
                                                                          : const Text("Yes, Confirm Booking"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
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
                                                            "Confirm Booking",
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
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xff7210FF),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                              ),
                                              onPressed: () => Get.toNamed(
                                                Routes.RECEIPT,
                                                arguments: bookings.id.toString(),
                                              ),
                                              child: const Text("View E-Receipt"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : bookings.status! == 'Upcoming' && bookings.confirm == 'Completed'
                                      ? SizedBox(
                                          height: 40,
                                          width: double.maxFinite,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff7210FF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                            ),
                                            onPressed: () {
                                              controller.rating.value = '';
                                              // RATING
                                              Get.dialog(
                                                barrierDismissible: false,
                                                AlertDialog(
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  ),
                                                  content: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      Text("text"),
                                                      Center(
                                                        child: RatingBar.builder(
                                                          glow: false,
                                                          minRating: 1,
                                                          itemSize: 30,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: false,
                                                          itemCount: 5,
                                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                          itemBuilder: (context, _) => const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          onRatingUpdate: (rating) {
                                                            controller.rating.value =
                                                                rating.toString().replaceAll('.0', '');
                                                            // print(rating.toString().replaceAll('.0', ''));
                                                          },
                                                        ),
                                                      ),
                                                      // REVIEW
                                                      Obx(
                                                        () => controller.rating.isNotEmpty
                                                            ? Column(
                                                                children: [
                                                                  const SizedBox(height: 20.0),
                                                                  TextFormField(
                                                                    maxLines: null,
                                                                    keyboardType: TextInputType.multiline,
                                                                    controller: controller.review,
                                                                    decoration: const InputDecoration(
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          width: 1.7,
                                                                          color: Color(0xff7210FF),
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      fillColor: Color(0xfffafafa),
                                                                      hintText: 'Enter your review',
                                                                      hintStyle: TextStyle(color: Colors.grey),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(10.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: const Color(0xfff1e7ff),
                                                          ),
                                                          onPressed: () {
                                                            controller.rating.value = '';
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            "cancel",
                                                            style: TextStyle(
                                                              color: Color(0xff7210FF),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10.0),
                                                        Obx(
                                                          () => ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xff7210FF),
                                                            ),
                                                            onPressed: () => controller.completedBooking(
                                                              bookings.id.toString(),
                                                              bookings.service!.id.toString(),
                                                              bookings.userId.toString(),
                                                              controller.review.text == ''
                                                                  ? null
                                                                  : controller.review.text,
                                                              controller.rating.value == ''
                                                                  ? null
                                                                  : controller.rating.value,
                                                            ),
                                                            child: controller.isLoading.isTrue
                                                                ? const SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth: 3,
                                                                      color: Colors.white,
                                                                    ),
                                                                  )
                                                                : const Text("save"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: const Text("Service Completed"),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 40,
                                          width: double.maxFinite,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff7210FF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                            ),
                                            onPressed: () => Get.toNamed(
                                              Routes.RECEIPT,
                                              arguments: bookings.id.toString(),
                                            ),
                                            child: const Text("View E-Receipt"),
                                          ),
                                        ),
                              const SizedBox(height: 10.0),
                              Center(
                                child: ExpandableButton(
                                  child: const RotatedBox(
                                    quarterTurns: -1,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 24.0,
                                      color: Color(0xff7210ff),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
