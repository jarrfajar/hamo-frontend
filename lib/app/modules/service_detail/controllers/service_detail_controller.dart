import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Service.dart';
import 'package:hamo/app/modules/home/controllers/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:hamo/app/models/Service.dart' as service_model;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isBookmar = false.obs;

  final listReview = RxList<Comments>();
  final listSerivce = RxList<service_model.Service>();

  List<String> review = [
    'All',
    '5',
    '4',
    '3',
    '2',
    '1',
  ];

  RxInt current = 0.obs;

  void changeReview(Service model) {
    if (current.value != 0) {
      var test = model.comments!.where((element) => element.rating! == review[current.value]).toList();
      listReview.clear();
      listReview.assignAll(test);
      // if (listReview.isEmpty) {
      //   listReview.insert(0, 'ls');
      // }
      print(['jumlah list', listReview.length]);
    }
  }

  // CONVERT DATE
  String converDate(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  // GET SERVICE
  Future<List<service_model.Service>> getService({required int id}) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (listSerivce.isEmpty) {
        // listSerivce.clear();
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        Uri url = Uri.parse('${Api.baseUrl}/service/$id');
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

  // BOOKMARK
  void bookmark({required int id}) async {
    final HomeController homeController = Get.find();
    final prefs = await SharedPreferences.getInstance();

    try {
      isBookmar.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');
      // GET IN FROM LOCAL MEMORY
      String? idUser = prefs.getString('id');

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
        listSerivce.first.favorite!.add(
          service_model.Favorite(
            serviceId: id,
            userId: int.parse(idUser.toString()),
          ),
        );
        listSerivce.refresh();

        // REMOVE BOOKMAR FROM HOMEPAGE
        var list = homeController.listSerivce.where((element) => element.id == id);
        list.first.favorite!.add(
          service_model.Favorite(
            serviceId: id,
            userId: int.parse(idUser.toString()),
          ),
        );
        homeController.listSerivce.refresh();
        homeController.dataku.refresh();
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

  // UNBOOKMARK
  void unbookmark({required int id}) async {
    final HomeController homeController = Get.find();
    final prefs = await SharedPreferences.getInstance();

    try {
      isBookmar.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');
      // // GET IN FROM LOCAL MEMORY
      // String? idUser = prefs.getString('id');

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
        listSerivce.first.favorite!.removeWhere((element) => element.serviceId == id);
        listSerivce.refresh();

        // REMOVE BOOKMAR FROM HOMEPAGE
        var a = homeController.listSerivce.where((element) => element.id == id);
        a.first.favorite!.removeWhere((element) => element.serviceId == id);
        homeController.listSerivce.refresh();
        homeController.dataku.refresh();
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
