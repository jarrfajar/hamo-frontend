import 'dart:convert';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptController extends GetxController {
  RxBool isLoading = false.obs;

  final receipt = RxList<Receipt>();

  Future<List<Receipt>> getReceipt(String id) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isLoading.value = true;
      if (receipt.isEmpty) {
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/trasaction/$id');
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
            receipt.addAll(data);
            print(response.body);
          }
          return receipt;
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
