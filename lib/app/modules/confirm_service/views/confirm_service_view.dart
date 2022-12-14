import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Profile.dart';
import 'package:hamo/app/models/confirmService.dart';
import 'package:hamo/app/reusable/bookingCard.dart';
import 'package:hamo/app/reusable/bottomSheet.dart';
import 'package:hamo/app/reusable/shimmer/category.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/confirm_service_controller.dart';

class ConfirmServiceView extends GetView<ConfirmServiceController> {
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
            'Your Booking Service',
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
              child: GetBuilder<ConfirmServiceController>(
                builder: (_) {
                  return TabBarView(
                    children: [
                      YourBookingService(
                        controller: controller,
                        status: 'Upcoming',
                        colors: const Color(0xff7210ff),
                        // confirm: null,
                      ),
                      YourBookingService(
                        controller: controller,
                        status: 'Completed',
                        colors: const Color(0xff4aaf57),
                        // confirm: 'Completed',
                      ),
                      YourBookingService(
                        controller: controller,
                        status: 'Cancelled',
                        colors: Colors.redAccent,
                        // confirm: 'Cancelled',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BODY
class YourBookingService extends StatelessWidget {
  const YourBookingService({
    required this.controller,
    required this.status,
    required this.colors,
    // required this.confirm,
    Key? key,
  }) : super(key: key);

  final ConfirmServiceController controller;
  final String status;
  final Color colors;
  // final String? confirm;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        FutureBuilder(
          future: controller.getService(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerService();
            }

            var data = controller.listSerivce.where((element) => element.status == status).toList();
            // var data = list.where((element) => element.confirm == confirm).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                ConfirmService bookings = data[index];

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
                                            color: colors,
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
                                        bookings.status == 'Cancelled' && bookings.confirm == null
                                            ? Column(
                                                children: const [
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "Booking canceled by user",
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
                                                    "waiting for service to finish by user",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff7210ff),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : bookings.confirm == 'Confirmed'
                                                ? Column(
                                                    children: const [
                                                      SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Text(
                                                        "waiting for service to finish",
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
                              // BUTTON
                              bookings.status == 'Upcoming' && bookings.confirm == 'Confirmed'
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
                                        onPressed: () => Get.bottomSheet(
                                          RsBottomSheet(
                                            height: Get.height * 0.3,
                                            title: "Service Completed?",
                                            body: "Are you sure want to Completed  your service booking?",
                                            onPressCancel: () => Get.back(),
                                            onPressConfirm: () => controller.completed(id: bookings.id.toString()),
                                            label: const Text("Yes, Completed"),
                                          ),
                                        ),
                                        child: controller.isLoading.isTrue
                                            ? const SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                "Service Completed?",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    )
                                  : bookings.status == 'Completed' ||
                                          bookings.status == 'Cancelled' ||
                                          bookings.confirm == 'Completed'
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
                                            // onPressed: () {},
                                            onPressed: () => Get.toNamed(
                                              Routes.RECEIPT,
                                              arguments: bookings.id.toString(),
                                            ),
                                            child: controller.isLoading.isTrue
                                                ? const SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text("View E-Receipt"),
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
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
                                                    RsBottomSheet(
                                                      height: Get.height * 0.3,
                                                      title: 'Cancel Booking',
                                                      body: "Are you sure want to cancel your service booking?",
                                                      onPressCancel: () => Get.back(),
                                                      onPressConfirm: () =>
                                                          controller.cancel(id: bookings.id.toString()),
                                                      label: const Text("Yes, Cancel Booking"),
                                                    ),
                                                  ),
                                                  child: controller.isLoading.isTrue
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
                                                        ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
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
                                                  onPressed: () {
                                                    Get.bottomSheet(
                                                      RsBottomSheet(
                                                        height: Get.height * 0.3,
                                                        title: 'Confirmation Booking',
                                                        body: "Are you sure want to Confirmation your service booking?",
                                                        onPressCancel: () => Get.back(),
                                                        onPressConfirm: () =>
                                                            controller.confirm(id: bookings.id.toString()),
                                                        label: const Text("Yes, Confirm Booking"),
                                                      ),
                                                    );
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
                                                      : const Text("Confirmation"),
                                                ),
                                              ),
                                            ),
                                          ],
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
