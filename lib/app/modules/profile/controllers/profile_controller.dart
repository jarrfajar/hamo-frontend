import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/controllers/page_index_controller.dart';
import 'package:hamo/app/models/Profile.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final PageIndexController pageController = Get.find();

  RxBool isLoading = false.obs;
  RxBool isLoadingLogout = false.obs;

  final profile = RxList<UserProfile>();

  // GET USERNAME AND TOKEN FROM LOCAL MEMORY
  RxString username = ''.obs;
  RxString token = ''.obs;

  var imageURL = '';

  final ImagePicker picker = ImagePicker();

  XFile? image;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('name')!;
    token.value = prefs.getString('token')!;
    // print([token.value, username.value]);
  }

  // PICK AND UPLOAD IMAGE
  void pickImage() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();

      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // GET IDUSER FROM LOCAL MEMORY
        String? id = prefs.getString('id');

        // UPLOAD IMAGE WITH DIO
        var formData = FormData.fromMap(
          {
            '_method': 'PUT',
            'image': await MultipartFile.fromFile(
              image!.path,
              filename: image!.name,
            ),
          },
        );
        var response = await Dio().post(
          '${Api.baseUrl}/profile/$id',
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Change profile picture success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (e) {
      print(['error', e]);
    } finally {
      update();
      isLoading.value = false;
    }
  }

  // GET PROFILE
  Future<List<UserProfile>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isLoading.value = true;
      // if (profile.isEmpty) {
      profile.clear();
      // GET TOKEN FROM LOCAL MEMORY
      String? token = prefs.getString('token');

      Uri url = Uri.parse('${Api.baseUrl}/profile');
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
      // }
    } catch (e) {
      print(['error', e]);
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  // LOGOUT
  void logout() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      isLoadingLogout.value = true;

      Uri url = Uri.parse('${Api.baseUrl}/logout');
      var response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // REMOVE TOKEN
        await prefs.remove('name');
        await prefs.remove('token');
        await prefs.remove('id');

        pageController.index.value = 0;

        Get.offAllNamed(Routes.LOGIN);
      } else {
        print(response.body);
        Fluttertoast.showToast(
          msg: "Logout Gagal",
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
      isLoadingLogout.value = false;
    }
  }
}
