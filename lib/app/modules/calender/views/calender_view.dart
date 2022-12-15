import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/controllers/page_index_controller.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:hamo/app/reusable/navigationBar.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/calender_controller.dart';

class CalenderView extends GetView<CalenderController> {
  final PageIndexController pageController = Get.find();

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
          'My Calender',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xfff1e7ff),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              selectionColor: const Color(0xff7210FF),
              initialSelectedDate: DateTime.now(),
              todayHighlightColor: const Color(0xff7210FF),
              showNavigationArrow: true,
              headerStyle: const DateRangePickerHeaderStyle(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onSelectionChanged: (date) {
                DateTime parseDate = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                var inputDate = DateTime.parse(parseDate.toString());

                controller.date.value = date.value.toString();
                print(controller.date.value);
                print(controller.bookings.length);

                // print(parseDate);
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),

          // SERVIS BODY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Service Booking',
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
          const SizedBox(height: 10.0),
          FutureBuilder(
            future: controller.getBooking(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerService();
              }

              // var data = controller.bookings.where((element) => element.status == 'Upcoming').toList();

              // var date = data.where((element) => element.date == controller.date.value).toList();
              // print(date.length);
              // print(['eee', controller.date.value]);

              return Obx(
                () => controller.bookings.where((element) => element.date == controller.date.value).toList().isEmpty
                    ? const Center(child: Text("tidak ada data :("))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // itemCount: data.where((element) => element.date == controller.date.value).toList().length,
                        itemCount: controller.bookings
                            .where((element) => element.date == controller.date.value)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          // Receipt bookings = data.where((element) => element.date == controller.date.value).toList()[index];
                          Receipt bookings = controller.bookings
                              .where((element) => element.date == controller.date.value)
                              .toList()[index];

                          return Container(
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
                            child: Row(
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
                                                color: const Color(0xff7210ff),
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
                                            const SizedBox(height: 10.0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavagationBar(
        controller: pageController.index.value,
        onChanged: (i) => pageController.changePage(i),
      ),
    );
  }
}
