import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamo/app/models/Profile.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);
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
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: controller.getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerService();
                }
                UserProfile profile = controller.profile.first;
                String gender = profile.profile!.gender ?? 'Select Gender';

                controller.phone.text = profile.profile!.phone ?? '';
                controller.address.text = profile.profile!.address ?? '';

                controller.birthdays.value = profile.profile!.birthday ?? 'birthday';

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: TextFormField(
                        initialValue: null,
                        decoration: InputDecoration.collapsed(
                          filled: true,
                          fillColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          hintText: profile.name,
                        ),
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () => Get.dialog(
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: ListView(
                            shrinkWrap: true,
                            children: [
                              SfDateRangePicker(
                                view: DateRangePickerView.month,
                                monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                                selectionColor: const Color(0xff7210FF),
                                initialSelectedDate: DateTime.now(),
                                todayHighlightColor: const Color(0xff7210FF),
                                showNavigationArrow: true,
                                headerStyle: const DateRangePickerHeaderStyle(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onSelectionChanged: (date) {
                                  DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date.value.toString());
                                  var inputDate = DateTime.parse(parseDate.toString());
                                  var outputFormat = DateFormat('dd-MM-yyyy');
                                  var outputDate = outputFormat.format(inputDate);

                                  controller.birthdays.value = outputDate;
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Obx(
                              () => Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  // controller: controller.birthday,
                                  initialValue: null,
                                  decoration: InputDecoration.collapsed(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    hintText: controller.birthdays.value,
                                  ),
                                  onFieldSubmitted: (value) {},
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.calendar_today_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: TextFormField(
                        initialValue: null,
                        decoration: InputDecoration.collapsed(
                          filled: true,
                          fillColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          hintText: profile.email,
                        ),
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: TextFormField(
                        initialValue: null,
                        controller: controller.phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration.collapsed(
                          filled: true,
                          fillColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          hintText: profile.profile!.phone ?? 'Phone',
                        ),
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          underline: const SizedBox(),
                          isExpanded: true,
                          hint: Text(gender.toString()),
                          onChanged: (e) {
                            controller.setSelectedTipeKamar(e.toString());
                          },
                          value: controller.gender.value == '' ? null : controller.gender.value,
                          items: controller.list.map((e) {
                            // print(e.tipeKamar?.tipeKamar);
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: controller.address,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.7,
                            color: Color(0xff7210FF),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        fillColor: const Color(0xfffafafa),
                        hintText: profile.profile!.address ?? 'Address',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                );
              }),

          // BUTTON
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7210FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () => controller.updateProfile(
                      birthday: controller.birthdays.value,
                      phone: controller.phone.text,
                      jk: controller.gender.value,
                      address: controller.address.text,
                    ),
                    child: controller.isLoading.isTrue
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Update"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
