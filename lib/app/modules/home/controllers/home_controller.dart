import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Category.dart';
import 'package:hamo/app/models/Service.dart' as service_model;
import 'package:hamo/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt current = 0.obs;

  RxBool isBookmar = false.obs;
  RxBool isUnBookmar = false.obs;

  final listCategory = RxList<Category>();
  final listTestCategory = RxList<Category>();
  final listSerivce = RxList<service_model.Service>();
  final dataku = RxList<service_model.Service>();

  // GET USERNAME AND TOKEN FROM LOCAL MEMORY
  RxString username = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      username.value = prefs.getString('name')!;
    }
  }

  @override
  void onClose() {
    listCategory.clear();
    listSerivce.clear();
    dataku.clear();
    super.onClose();
  }

  // CATEGORY
  Future<List<Category>> getCategoryService() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isLoading.value = true;
      if (listCategory.isEmpty) {
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/category');
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final List<Category> data = (json.decode(response.body) as Map<String, dynamic>)['data']
            .map((json) => Category.fromJson(json))
            .toList()
            .cast<Category>();

        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            listCategory.addAll(data);
            listTestCategory.addAll(data);
            listCategory.insert(
              0,
              Category(name: 'All'),
            );
          }
          return listCategory;
        }
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  // SERVICE
  Future<List<service_model.Service>> getService() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (listSerivce.isEmpty) {
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/service');
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final List<service_model.Service> data = (json.decode(response.body) as Map<String, dynamic>)['data']
            .map((json) => service_model.Service.fromJson(json))
            .toList()
            .cast<service_model.Service>();

        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            listSerivce.addAll(data);
          }
          return listSerivce;
        }
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  // CHANGE PAGE
  void show(int index) {
    if (index != 0) {
      var data = listSerivce.where((e) => e.category?.id == index).toList();
      dataku.clear();
      dataku.assignAll(data);
    } else {
      listSerivce;
      dataku.assignAll(listSerivce);
    }
  }

  // UNBOOKMARK
  void unBookmark({required int id, required int index, required bool status}) async {
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
        listSerivce[index].favorite!.removeWhere((element) => element.serviceId == id);
        dataku.refresh();
        listSerivce.refresh();
      } else {
        Fluttertoast.showToast(
          msg: "Kesalahan server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isUnBookmar.value = false;
    }
  }

  // BOOKMARK
  void bookmark({required int id, required int index, required bool status}) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isBookmar.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/favorite/$id');
      var response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Bookmar disimpan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        listSerivce[index].favorite!.add(service_model.Favorite(serviceId: id));
        dataku.refresh();
        listSerivce.refresh();
      } else {
        Fluttertoast.showToast(
          msg: "Kesalahan server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isBookmar.value = false;
    }
  }
}
