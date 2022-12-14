import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/models/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = false.obs;
  final profile = RxList<UserProfile>();

  final RxString birthdays = "".obs;

  final RxString gender = "".obs;
  List<String> list = ['Male', 'Female'];

  final ImagePicker picker = ImagePicker();

  late TextEditingController birthday, address, phone;

  @override
  void onInit() {
    super.onInit();
    birthday = TextEditingController();
    address = TextEditingController();
    phone = TextEditingController();
  }

  @override
  void onClose() {
    birthday.dispose();
    address.dispose();
    phone.dispose();
    super.onClose();
  }

  void setSelectedTipeKamar(String value) {
    gender.value = value;
  }

  // PROFILE
  Future<List<UserProfile>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      profile.clear();
      isLoading.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');
      String? id = prefs.getString('id');

      Uri url = Uri.parse('${Api.baseUrl}/profile/$id');
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      final List<UserProfile> data = (json.decode(response.body) as Map<String, dynamic>)['data']
          .map((json) => UserProfile.fromJson(json))
          .toList()
          .cast<UserProfile>();

      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          profile.addAll(data);
        }
        return profile;
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  // UPDATE PROFILE
  void updateProfile({
    required String birthday,
    required String phone,
    required String jk,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      profile.clear();
      isLoading.value = true;
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');
      String? id = prefs.getString('id');

      Uri url = Uri.parse('${Api.baseUrl}/profile/$id');

      final body = {
        'user_id': int.parse(id!),
        '_method': 'PUT',
        'birthday': birthday,
        'phone': phone,
        'gender': jk,
        'address': address,
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
        Fluttertoast.showToast(
          msg: "Update Profile Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(['error', e]);
      Fluttertoast.showToast(
        msg: "Error $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
