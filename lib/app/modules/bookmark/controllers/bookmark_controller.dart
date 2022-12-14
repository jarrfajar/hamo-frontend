import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/bookmarks.dart';
import 'package:hamo/app/modules/home/controllers/home_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkController extends GetxController {
  final HomeController homeController = Get.find();

  RxBool isLoading = false.obs;
  RxBool isUnBookmar = false.obs;

  RxString keyword = ''.obs;
  RxString count = ''.obs;

  final listBookmarks = RxList<Bookmarks>();
  final listBookmarksSearch = RxList<Bookmarks>();

  Future<List<Bookmarks>> getBookmark() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (listBookmarks.isEmpty) {
        isLoading.value = true;
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/bookmarks');
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final List<Bookmarks> data = (json.decode(response.body) as Map<String, dynamic>)['data']
            .map((json) => Bookmarks.fromJson(json))
            .toList()
            .cast<Bookmarks>();

        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            listBookmarks.addAll(data);
          }
          return listBookmarks;
        }
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  // UNBOOKMAR
  void unbookmar({required String id}) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isUnBookmar.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/unfavorite/$id');
      var response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Bookmar dihapus",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        listBookmarks.removeWhere((element) => element.id == int.parse(id));
        listBookmarks.refresh();

        // REMOVE BOOKMAR FROM HOMEPAGE
        var a = homeController.listSerivce.where((element) => element.id == int.parse(id));
        a.first.favorite!.removeWhere((element) => element.serviceId == int.parse(id));
        homeController.listSerivce.refresh();
        homeController.dataku.refresh();

        Get.back();
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isUnBookmar.value = false;
    }
  }

  // SEARCH
  searchChanged(String value) {
    // RxList<Service> service = homeController.listSerivce;
    if (value.isNotEmpty) {
      keyword.value = value;
      var cari =
          listBookmarks.where((element) => element.title!.toLowerCase().contains(value.toLowerCase())).toList().obs;

      count.value = cari.length.toString();
      listBookmarksSearch.addAll(cari);
    } else {
      keyword.value = '';
      listBookmarksSearch.clear();
      listBookmarks;
    }
  }
}
