import 'dart:convert';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Category.dart' as category_model;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends GetxController {
  final listCategory = RxList<category_model.Category>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<category_model.Category>> getCategory() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (listCategory.isEmpty) {
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/category');
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final List<category_model.Category> data = (json.decode(response.body) as Map<String, dynamic>)['data']
            .map((json) => category_model.Category.fromJson(json))
            .toList()
            .cast<category_model.Category>();
        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            listCategory.addAll(data);
          }
          return listCategory;
        }
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
