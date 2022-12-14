import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingDetailsController extends GetxController {
  RxString transactionID = ''.obs;

  final count = 1.obs;
  RxInt current = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isSuccess = false.obs;

  RxString date = ''.obs;
  RxString time = '09:00'.obs;

  DateTime datetime = DateTime(1990, 1, 1, 9, 00);
  String shift = "";
  List<String> timeWork = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];

  RxString hargaAwal = ''.obs;
  RxString total = ''.obs;

  late TextEditingController description, address;

  @override
  void onInit() {
    super.onInit();
    description = TextEditingController();
    address = TextEditingController();
  }

  @override
  void onClose() {
    description.dispose();
    address.dispose();
    super.onClose();
  }

  void increment() {
    count.value++;
    int getTotal = int.parse(total.value) + int.parse(hargaAwal.value);
    total.value = getTotal.toString();
  }

  void decrement() {
    if (count.value != 1) {
      count.value--;
      int getTotal = int.parse(total.value) - int.parse(hargaAwal.value);
      total.value = getTotal.toString();
    }
  }

  void hours() {
    while (shift != "17:00") {
      shift = DateFormat(DateFormat.HOUR24_MINUTE).format(datetime);
      timeWork.add(shift);
      datetime = datetime.add(const Duration(hours: 1));
    }
    // print(time);
  }

  // CREATE TRANSACTION
  void transaction({
    required int serviceID,
    required int categoryID,
    // required int userID,
    required String date,
    required String time,
    required int hours,
    required String description,
    required String address,
    required String amount,
    required String status,
    required String penjual_id,
  }) async {
    // GET TOKEN AND IDUSER FROM LOCAL MEMORY
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');

    if (date.isEmpty || time.isEmail || hours == 0 || description.isEmpty || address.isEmpty) {
      Fluttertoast.showToast(
        msg: "Date, time, hours, description, address is required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      try {
        isLoading.value = true;
        transactionID.value = '';
        Uri url = Uri.parse('${Api.baseUrl}/trasaction');

        final body = {
          'service_id': serviceID,
          'category_id': categoryID,
          'user_id': int.parse(id!),
          'penjual_id': penjual_id,
          'date': date,
          'time': time,
          'hours': hours,
          'description': description,
          'address': address,
          'amount': amount,
          'status': status,
        };

        var response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body));

        if (response.statusCode == 201) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          // // GET RESPONSE
          transactionID.value = data['data']['id'].toString();

          Fluttertoast.showToast(
            msg: "Trasaction Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // DIALOG SUCCESS
          Get.dialog(
            barrierDismissible: false,
            AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              content: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: const BoxDecoration(
                      color: Color(0xff7210FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_box_rounded,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Center(
                    child: Text(
                      "Booking Succesfull!",
                      style: TextStyle(
                        color: Color(0xff7210FF),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Center(
                    child: Text(
                      "You have successfully made payment and book the services.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7210FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.RECEIPT, arguments: transactionID.value),
                      child: const Text("View E-Receipt"),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfff1e7ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () => Get.offAllNamed(Routes.HOME),
                      child: const Text(
                        "Back to home",
                        style: TextStyle(
                          color: Color(0xff7210FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      } catch (e) {
        print(['error', e]);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
