import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController email, password;

  // VALIDASI LOGIN
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  var emailValidate = '';
  var passwordValidate = '';

  @override
  void onInit() {
    super.onInit();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }

  // VALIDASI EMAIL
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isEmail) {
      return 'Email is not valid';
    }
    return null;
  }

  // VALIDASI PASSWORD
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      var a = value.length - 8;
      var b = a.toString();
      return 'Password less than ${b.substring(1)} characters';
    }
    return null;
  }

  login({required String email, required String password}) async {
    final pref = await SharedPreferences.getInstance();

    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    try {
      isLoading.value = true;

      Uri url = Uri.parse('${Api.baseUrl}/login');
      var response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        // GET RESPONSE
        var name = data['name'];
        var token = data['access_token'];
        var id = data['id'];

        // SAVE RESPONSE IN LOCAL MEMORY
        pref.setString('name', name);
        pref.setString('token', token);
        pref.setString('id', id.toString());

        Get.offAllNamed(Routes.HOME);
      } else {
        print(response.body);
        Fluttertoast.showToast(
          msg: "Register Gagal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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
