import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/data/currency.dart';
import 'package:hamo/app/models/Service.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/booking_details_controller.dart';

class BookingDetailsView extends GetView<BookingDetailsController> {
  Service service = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.hargaAwal.value = service.price!;
    controller.total.value = service.price!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const Text(
            "Select Date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
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
                // DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.value.toString());
                // var inputDate = DateTime.parse(parseDate.toString());
                // var outputFormat = DateFormat('dd-MM-yyyy');
                // var outputDate = outputFormat.format(inputDate);
                // print(outputDate);

                controller.date.value = date.value.toString();
                print(controller.date.value);
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Working Hours',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Cost increase after 2 hrs of work',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.decrement(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xfff1e7ff),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.remove_outlined,
                          color: Color(0xff7210FF),
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.count.value.toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.increment(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xfff1e7ff),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xff7210FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Choose Start Time",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 40.0,
            child: ListView.builder(
              itemCount: controller.timeWork.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String time = controller.timeWork[index];

                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.current.value = index;
                      controller.time.value = controller.timeWork[index];
                      print(controller.time.value);
                    },
                    child: Container(
                      width: 80.0,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: controller.current.value == index ? const Color(0xff7210FF) : Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: const Color(0xff7210FF),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: controller.current.value == index ? Colors.white : const Color(0xff7210ff),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          // DESCRIPTION
          const Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller.description,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.7,
                  color: Color(0xff7210FF),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              fillColor: Color(0xfffafafa),
              hintText: 'Example: cat tembok warna merah dan biru',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          // ADDRESS
          const Text(
            "Address",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          TextFormField(
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            controller: controller.address,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.7,
                  color: Color(0xff7210FF),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              fillColor: Color(0xfffafafa),
              hintText:
                  'Example: Jl. Kartika Raya No.4, RT.6/RW.6, Pengadegan, Kec. Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12930',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),

          Obx(
            () => SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7210FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  controller.transaction(
                    serviceID: service.id!,
                    categoryID: service.category!.id!,
                    date: controller.date.value,
                    time: controller.time.value,
                    hours: controller.count.value,
                    description: controller.description.text,
                    address: controller.address.text,
                    amount: controller.total.value,
                    status: 'Upcoming',
                    penjual_id: service.userId.toString(),
                  );
                  print(['success', controller.transactionID.value]);
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
                    : Text("Book Now | ${CurrencyFormat.convertToIdr(int.parse(controller.total.value))}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
