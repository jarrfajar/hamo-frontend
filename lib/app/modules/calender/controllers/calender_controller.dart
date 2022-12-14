import 'dart:convert';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CalenderController extends GetxController {
  RxString date = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).toString().obs;
  RxInt count = 0.obs;

  RxBool isLoading = false.obs;
  final bookings = RxList<Receipt>();

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
          print(response.body);
          if (data.isNotEmpty) {
            var upcoming = data.where((elemet) => elemet.status == 'Upcoming').toList();

            bookings.addAll(upcoming);
          }
          print(bookings.length);
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
}
