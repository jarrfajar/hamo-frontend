import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController email, password, passwordConfirm, username;

  // VALIDASI LOGIN
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  var emailValidate = '';
  var passwordValidate = '';
  var passwordConfirmValidate = '';
  var usernameValidate = '';

  @override
  void onInit() {
    super.onInit();
    email = TextEditingController();
    password = TextEditingController();
    passwordConfirm = TextEditingController();
    username = TextEditingController();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    username.dispose();
    super.onClose();
  }

  // VALIDASI USERNAME
  String? validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 5) {
      var a = value.length - 5;
      var b = a.toString();
      return 'Username less than ${b.substring(1)} characters';
    }
    return null;
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

  // VALIDASI PASSWORD CONFIRM
  String? validatePasswordConfirm(String value) {
    if (value.isEmpty) {
      return 'Confirmation password is required';
    }
    if (value.length < 8) {
      var a = value.length - 8;
      var b = a.toString();
      return 'Password less than ${b.substring(1)} characters';
    }
    if (value != password.text) {
      return 'Confirmation password is not match';
    }
    return null;
  }

  // REGISTER
  void register({
    required String email,
    required String password,
    required String username,
  }) async {
    final pref = await SharedPreferences.getInstance();

    final isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    try {
      isLoading.value = true;

      Uri url = Uri.parse('${Api.baseUrl}/register');
      var response = await http.post(url, body: {
        'name': username,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        // GET RESPONSE
        var name = data['data']['name'];
        var token = data['access_token'];

        // SAVE RESPONSE IN LOCAL MEMORY
        pref.setString('name', name);
        pref.setString('token', token);

        Get.offAllNamed(Routes.HOME);
        Fluttertoast.showToast(
          msg: "Register success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
