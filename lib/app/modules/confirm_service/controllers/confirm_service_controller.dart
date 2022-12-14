import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Profile.dart';
import 'package:hamo/app/models/confirmService.dart';
import 'package:hamo/app/modules/profile/controllers/profile_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmServiceController extends GetxController {
  final ProfileController profileController = Get.find();

  final listSerivce = RxList<ConfirmService>();

  RxBool isLoading = false.obs;

  // SERVICE
  Future<List<ConfirmService>> getService() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (listSerivce.isEmpty) {
        // GET TOKEN FROM LOCAL MEMORY
        String? token = prefs.getString('token');

        // Uri url = Uri.parse('${Api.baseUrl}/trasaction');
        Uri url = Uri.parse('${Api.baseUrl}/trasaction-booking');
        var response = await http.get(url, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final List<ConfirmService> data = (json.decode(response.body) as Map<String, dynamic>)['data']
            .map((json) => ConfirmService.fromJson(json))
            .toList()
            .cast<ConfirmService>();

        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            listSerivce.addAll(data);
          }
          return listSerivce;
        }
      }
    } catch (e) {
      print(['error', e]);
    }
    return [];
  }

  // CONFIRM
  void confirm({required String id}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/trasaction-booking/$id');

      final body = {
        '_method': 'PUT',
        'confirm': 'Confirmed',
        // 'status': 'Upcoming',
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
        print('success');
        var data = listSerivce.firstWhere((element) => element.id == int.parse(id));
        data.confirm = 'Confirmed';
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

  // USER HARUS KONFIRMASI PESSANAN SELESAI JUGA DAN BERI RATING

  // COMPLETED
  void completed({required String id}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/trasaction-booking/$id');

      final body = {
        '_method': 'PUT',
        // 'status': 'Completed',
        'confirm': 'Completed',
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
        print('success');
        var data = listSerivce.firstWhere((element) => element.id == int.parse(id));
        // data.status = 'Completed';
        data.confirm = 'Completed';
        update();

        // profileController.profile.first.transactions!.removeWhere((element) => element.id == int.parse(id));
        // profileController.profile.refresh();
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

  // CANCELL
  void cancel({required String id}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/confirm/$id');

      final body = {
        '_method': 'PUT',
        'status': 'Cancelled',
        'confirm': 'cancell',
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
        print('success');
        var data = listSerivce.firstWhere((element) => element.id == int.parse(id));
        data.status = 'Cancelled';
        data.confirm = 'cancell';
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
}
