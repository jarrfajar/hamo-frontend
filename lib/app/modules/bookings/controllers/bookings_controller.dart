import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingsController extends GetxController {
  RxBool isLoading = false.obs;

  final bookings = RxList<Receipt>();
  RxString rating = ''.obs;

  late TextEditingController review;

  @override
  void onInit() {
    super.onInit();
    review = TextEditingController();
  }

  @override
  void onClose() {
    review.dispose();
    super.onClose();
  }

  Future<List<Receipt>> getBooking() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isLoading.value = true;
      if (bookings.isEmpty) {
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/trasaction');
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final List<Receipt> data = (json.decode(response.body) as Map<String, dynamic>)['data']
            .map((json) => Receipt.fromJson(json))
            .toList()
            .cast<Receipt>();

        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            bookings.addAll(data);
          }
          return bookings;
        }
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  // BOOKING COMPLETED
  void completedBooking(
    String id,
    String? serviceId,
    String? userId,
    String? description,
    String? rating,
  ) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/trasaction/$id');

      final body = {
        '_method': 'PUT',
        'status': 'Completed',
        'service_id': serviceId,
        'user_id': userId,
        'description': description,
        'rating': rating,
      };

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        var data = bookings.firstWhere((element) => element.id == int.parse(id));
        data.status = 'Completed';
        update();
        Get.back();
      } else {
        print('gagal');
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
  }

  void cancelBooking({required String id}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      isLoading.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/trasaction/$id');

      final body = {
        '_method': 'PUT',
        'status': 'Cancelled',
      };
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // UPDATE LIST
        var data = bookings.firstWhere((element) => element.id == int.parse(id));
        data.status = 'Cancelled';
        update();
        Get.back();

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
                    "Cancel Booking Succesfull!",
                    textAlign: TextAlign.center,
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
                    "You have successfully canceled your service booking.",
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
                    onPressed: () => Get.back(),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
  }
}
