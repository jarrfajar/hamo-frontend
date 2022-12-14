import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/api/api.dart';
import 'package:hamo/app/controllers/page_index_controller.dart';
import 'package:hamo/app/models/Profile.dart';
import 'package:hamo/app/reusable/navigationBar.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:hamo/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final PageIndexController pageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: controller.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerService();
          }
          // UserProfile profile = controller.profile.first;
          UserProfile profile = controller.profile.first;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    GetBuilder<ProfileController>(
                      builder: (c) {
                        // if (profile.profile!.image != null && c.image != null) {
                        if (profile.profile!.image != null) {
                          return ClipOval(
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red,
                              ),
                              // child: Image.file(
                              //   File(c.image!.path),
                              //   fit: BoxFit.cover,
                              // ),
                              child: c.image != null
                                  ? Image.file(
                                      File(c.image!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      '${Api.domainUrl}/${profile.profile!.image}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        } else {
                          return ClipOval(
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blue,
                              ),
                              child: Image.network(
                                'https://ui-avatars.com/api/?name=Fajar+Yasin',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff7210FF),
                        ),
                        child: GestureDetector(
                          onTap: () => controller.pickImage(),
                          child: controller.isLoading.isTrue
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.edit_note_rounded,
                                  size: 28.0,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Center(
                child: Text(
                  profile.name.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(
                thickness: 2,
                color: Color(0xffeeeeee),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.person_outline_outlined,
                          size: 26.0,
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              (profile.roles!.first.name == 'seller' || profile.roles!.first.name == 'admin'
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.CONFIRM_SERVICE),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.store_mall_directory_outlined,
                                    size: 26.0,
                                  ),
                                  const SizedBox(width: 15.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Booking Service',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: const Color(0xff7210FF),
                                        ),
                                        child: Center(
                                          child: Obx(
                                            () => Text(
                                              '${controller.profile.first.transaction?.length}',
                                              // '${profile.transactions?.length}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    )
                  : const SizedBox()),
              GestureDetector(
                onTap: () => Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: Get.height * 0.3,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          height: 5,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          'Logout?',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(
                          thickness: 2,
                          color: Color(0xffeeeeee),
                        ),
                        const SizedBox(height: 10.0),
                        const Center(
                          child: Text(
                            "Are you sure want to log out?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // BOTTOM
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xfff1e7ff),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  onPressed: () => Get.back(),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Color(0xff7210FF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Obx(
                                () => SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff7210FF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    onPressed: () => controller.logout(),
                                    child: controller.isLoadingLogout.isTrue
                                        ? const SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text("Yes, Logout"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      size: 26.0,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 15.0),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: NavagationBar(
        controller: pageController.index.value,
        onChanged: (i) => pageController.changePage(i),
      ),
    );
  }
}
